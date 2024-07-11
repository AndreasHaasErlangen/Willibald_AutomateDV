{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: 
    - stg_webshop_kunde
src_pk: hk_customer_h
src_nk: customer_bk
src_ldts: ldts
src_source: rsrc
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.hub(src_pk=metadata_dict["src_pk"],
                   src_nk=metadata_dict["src_nk"], 
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_ldts"],
                   source_model=metadata_dict["source_model"]) }}
