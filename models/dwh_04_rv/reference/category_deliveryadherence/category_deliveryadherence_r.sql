{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: 
    - stg_misc_kategorie_termintreue
src_pk: category_deliveryadherence_nk
src_ldts: ldts
src_source: rsrc
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.ref_table(src_pk=metadata_dict["src_pk"],
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"]) }}




