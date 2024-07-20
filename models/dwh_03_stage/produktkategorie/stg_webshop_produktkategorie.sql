{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_produktkategorie'
hashed_columns:
  hk_productcategory_h:
    - katid
  hk_productcategory_parent_h:
    - oberkatid
  hk_productcategory_hierarchy_l:
    - productcategory_parent_bk
    - productcategory_bk
  hd_productcategory_ws_s:
    is_hashdiff: true
    columns:
      - name


derived_columns:
    productcategory_bk:
      - katid
    productcategory_parent_bk:
      - oberkatid

    cdts:
      - {{var("local_timestamp")}}
    edts:      
      - edts_in


rsrc: 'rsrc' 
ldts: 'ldts'
include_source_columns: true

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=metadata_dict['include_source_columns'],
                  source_model=metadata_dict['source_model'],
                  hashed_columns=metadata_dict['hashed_columns'],
                  derived_columns=metadata_dict['derived_columns']) }}

where is_check_ok or rsrc ='SYSTEM'                  