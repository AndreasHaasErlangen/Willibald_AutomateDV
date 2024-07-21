{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_lieferung'
hashed_columns:
  hk_deliveryadress_h:
    - lieferadrid
  hk_deliveryservice_h:
    - lieferdienstid
  hk_order_h:
    - bestellungid
  hk_position_h:
    - bestellungid
    - posid
  hk_order_position_l:
    - position_bk
    - order_bk
  hk_delivery_l:
    - lieferadrid
    - lieferdienstid
    - bestellungid
    - bestellungid
    - posid
  hd_position_ws_s:
    is_hashdiff: true
    columns:
      - bestellungid
      - posid


derived_columns:
    deliveryadress_bk:
      - lieferadrid
    deliveryservice_bk:
      - lieferdienstid
    order_bk:
      - bestellungid
    position_bk:
      - bestellungid||'_'||posid

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