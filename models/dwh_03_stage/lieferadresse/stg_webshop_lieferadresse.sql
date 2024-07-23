{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_lieferadresse'
hashed_columns:
  hk_customer_h:
    - kundeid
  hk_deliveryadress_h:
    - lieferadrid
  hk_deliveryadress_customer_l:
    - deliveryadress_bk
    - customer_bk
  hd_deliveryadress_ws_s:
    is_hashdiff: true
    columns:
      - adresszusatz
      - hausnummer
      - land
      - ort
      - plz
      - strasse


derived_columns:
    customer_bk:
      - kundeid
    deliveryadress_bk:
      - lieferadrid

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