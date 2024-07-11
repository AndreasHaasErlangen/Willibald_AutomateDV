{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_bestellung'
hashed_columns:
  hk_customer_h:
    - kundeid
  hk_order_h:
    - bestellungid
  hk_order_customer_l:
    - order_bk
    - customer_bk
  hd_order_ws_s:
    is_hashdiff: true
    columns:
      - allglieferadrid
      - bestelldatum
      - rabatt
      - wunschdatum




derived_columns:
    customer_bk:
      - kundeid
    order_bk:
      - bestellungid


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