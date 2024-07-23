{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_vereinspartner'
hashed_columns:
  hk_associationpartner_h:
    - vereinspartnerid
  hk_customer_h:
    - kundeidverein
  hk_associationpartner_customer_l:
    - customer_bk
    - associationpartner_bk
  hd_associationpartner_ws_s:
    is_hashdiff: true
    columns:
      - kundeidverein
      - rabatt1
      - rabatt2
      - rabatt3


derived_columns:
    associationpartner_bk:
      - vereinspartnerid
    customer_bk:
      - kundeidverein

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