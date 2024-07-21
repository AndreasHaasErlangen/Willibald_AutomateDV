{{ config(materialized='incremental') }}

{%- set source_model = 'stg_misc_kategorie_termintreue'           -%}
{%- set src_pk = 'category_deliveryadherence_nk'                          -%}
{%- set src_ldts = 'ldts'                          -%}
{%- set src_source = 'rsrc'                          -%}

{{ automate_dv.ref_table(src_pk=src_pk, 
                         source_model=source_model,
                         src_ldts=src_ldts,
                         src_source=src_source) }}


