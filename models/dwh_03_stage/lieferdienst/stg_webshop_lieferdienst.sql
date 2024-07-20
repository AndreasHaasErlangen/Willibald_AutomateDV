{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_lieferdienst'
hashed_columns:
  hk_deliveryservice_h:
    - lieferdienstid
  hd_deliveryservice_ws_s:
    is_hashdiff: true
    columns:
      - email
      - fax
      - hausnummer
      - land
      - name
      - ort
      - plz
      - strasse
      - telefon


derived_columns:
    deliveryservice_bk:
      - lieferdienstid

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