{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_produkt'
hashed_columns:
  hk_product_h:
    - produktid
  hk_productcategory_h:
    - katid
  hk_product_productcategory_l:
    - productcategory_bk
    - product_bk
  hd_product_ws_s:
    is_hashdiff: true
    columns:
      - bezeichnung
      - pflanzabstand
      - pflanzort
      - preis
      - typ
      - umfang


derived_columns:
    product_bk:
      - produktid
    productcategory_bk:
      - katid

    cdts:
      - {{var("local_timestamp")}}
    edts:      
      - edts_in


rsrc: 'rsrc_source' 
ldts: 'ldts_source'
include_source_columns: true

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=metadata_dict['include_source_columns'],
                  source_model=metadata_dict['source_model'],
                  hashed_columns=metadata_dict['hashed_columns'],
                  derived_columns=metadata_dict['derived_columns']) }}

where is_check_ok or rsrc_source ='SYSTEM'                  