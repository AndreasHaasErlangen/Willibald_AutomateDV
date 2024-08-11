

{%- macro psa(source_model, src_pk, columns_to_exclude, src_payload, src_eff, src_ldts) -%}

    {{- automate_dv.check_required_parameters(
        source_model=source_model, 
        src_pk=src_pk, 
        columns_to_exclude=columns_to_exclude,
        src_payload=src_payload,
        src_ldts=src_ldts
    ) -}}

    {{ prepend_generated_by() }}

    {{ adapter.dispatch('psa')(
        source_model=source_model, 
        src_pk=src_pk,
        columns_to_exclude=columns_to_exclude,
        src_payload=src_payload,
        src_ldts=src_ldts
    ) -}}

{%- endmacro -%}

{%- macro default__psa(
    source_model,
    src_pk, 
    columns_to_exclude,
    src_payload, 
    src_ldts 
    ) -%}

{# If src_payload is defined, these columns will be used as relevant for the target table                #}
{# otherwise all columns available within the sourcc_model will be used except the ones defined in columns_to_exclude        #}



{% set source_columns = adapter.get_columns_in_relation(ref(source_model)) | map(attribute='name') | map('upper') | list %}

{%- set columns_to_exclude = columns_to_exclude | map('upper') | list -%}

{%- set relevant_source_columns = [] -%}

{%- for column in source_columns -%}
    {%- if column not in columns_to_exclude -%}
        {%- do relevant_source_columns.append(column) -%}
    {%- endif -%}
{%- endfor -%}

--source_columns: {{ source_columns }}
--columns_to_exclude: {{ columns_to_exclude }}
--relevant_source_columns: {{ relevant_source_columns }}





WITH cte_incoming_view AS
    (
    SELECT TOP 5
        *,
        '{{ source_model }}' AS meta_filename,
        '{{ source_model }}' AS meta_rsrc,
        CURRENT_TIMESTAMP() AS erstell_mut_datum,
        {{ src_ldts }} AS meta_eventldts,
        {{ src_ldts }} AS meta_ldts,
        SHA2_BINARY(CONCAT(
            {%- for column in src_payload %}
            IFNULL({{ column.upper() }}::VARCHAR, '<=NULL=>')
            {%- if not loop.last %} || ',' ||{%- endif %}
            {%- endfor %}
        )) AS meta_psa_recordhash,
        CONCAT({{ src_pk }}) AS meta_pk_concat,
        ROW_NUMBER AS meta_filerowid
    FROM {{ ref(source_model) }}  
)
, cte_incoming_change_indicator AS
    (
    SELECT
        cte_incoming_view.*,
        CASE
            WHEN LAG(meta_psa_recordhash, 1) OVER (
                PARTITION BY meta_pk_concat
                ORDER BY meta_rsrc, meta_filerowid
            ) = meta_psa_recordhash THEN 'Same'
            ELSE 'Different'
        END AS value_change_indicator
    FROM cte_incoming_view
    )
--select * from cte_incoming_change_indicator
, cte_incoming_condense AS 
    (
    SELECT
        cte_incoming_change_indicator.*,
        ROW_NUMBER() OVER (
            PARTITION BY meta_pk_concat
            ORDER BY meta_filerowid
        ) AS key_row_number
    FROM cte_incoming_change_indicator
    WHERE value_change_indicator = 'Different'
    )
--select * from cte_incoming_condense
{%- if adapter.get_relation(this.database, this.schema, this.identifier) is not none %}

, cte_max_ldts AS
    (
    SELECT 
        MAX(meta_ldts) AS max_ldts,
        {{ src_pk }},
        CONCAT({{ src_pk }}) AS meta_pk_concat
    FROM {{ this }}
    GROUP BY {{ src_pk }},
        CONCAT({{ src_pk }}) 
    )
--select * from cte_max_ldts
, cte_most_recent AS (
    SELECT
        psa.*,
        meta_pk_concat
    FROM {{ this }} psa
    JOIN cte_max_ldts psamax ON
        psa.{{ src_pk }} = psamax.{{ src_pk }}
        AND psa.meta_ldts = psamax.max_ldts
    WHERE
        psa.meta_psa_cdcoperation != 'Delete'
)
--select * from cte_most_recent 
, cte_records_to_insert as (
    SELECT
        {%- for field in src_payload %}
        IFF(IV.meta_filerowid IS NULL, MR.{{ field | upper }}, IV.{{ field | upper }}) AS {{ field | upper }},
        {%- endfor %}
        IFF(IV.meta_filerowid IS NULL, MR.meta_psa_recordhash, IV.meta_psa_recordhash) AS meta_psa_recordhash,
        IFF(IV.meta_filerowid IS NULL, MR.erstell_mut_datum, IV.erstell_mut_datum) AS erstell_mut_datum,
        IFF(IV.meta_filerowid IS NULL, MR.meta_filename, IV.meta_filename) AS meta_filename,
        IFF(IV.meta_filerowid IS NULL, 'CDC DETECTION', IV.meta_rsrc) AS meta_rsrc,
        IFF(IV.meta_filerowid IS NULL, -1, IV.meta_filerowid) AS meta_filerowid,
        CURRENT_TIMESTAMP() AS meta_ldts,
        IFF(IV.meta_filerowid IS NULL, CURRENT_TIMESTAMP(), IV.meta_eventldts) AS meta_eventldts,
        ':2' AS meta_etl_process_id,
        ':3' AS meta_etl_batch_id,
        CASE
            WHEN IV.meta_pk_concat IS NULL THEN 'Delete'
            WHEN MR.meta_pk_concat IS NULL THEN 'Insert'
            WHEN IV.meta_pk_concat IS NOT NULL
                AND MR.meta_pk_concat IS NOT NULL
                AND IV.meta_psa_recordhash <> MR.meta_psa_recordhash THEN 'Change'
            ELSE 'No Change'
        END AS meta_psa_cdcoperation
    FROM cte_incoming_condense IV
    FULL OUTER JOIN cte_most_recent MR ON IV.meta_pk_concat = MR.meta_pk_concat
    WHERE (
        CASE
            WHEN IV.meta_pk_concat IS NULL THEN 'Delete'
            WHEN MR.meta_pk_concat IS NULL THEN 'Insert'
            WHEN IV.meta_pk_concat IS NOT NULL
                AND MR.meta_pk_concat IS NOT NULL
                AND IV.meta_psa_recordhash <> MR.meta_psa_recordhash THEN 'Change'
            ELSE 'No Change'
        END
    ) != 'No Change'
) 
{% else %}
, cte_records_to_insert AS (
			 
    SELECT 
        {%- for field in src_payload %}
        {{ field | upper }},
        {%- endfor %}
        meta_psa_recordhash,
        erstell_mut_datum,
        meta_filename,
        meta_rsrc,
        meta_filerowid,
        meta_ldts,
        meta_eventldts,
        ':2' AS meta_etl_process_id,
        ':3' AS meta_etl_batch_id,
        'Insert' AS meta_psa_cdcoperation
    FROM cte_incoming_condense
)
{% endif %}

SELECT * FROM cte_records_to_insert
{%- endmacro -%}
