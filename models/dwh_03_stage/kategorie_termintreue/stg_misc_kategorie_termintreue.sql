{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 
  'load_misc_kategorie_termintreue'
hashed_columns:
  hd_category_deliveryadherence_misc_rs:
    is_hashdiff: true
    columns:
      - anzahl_tage_von
      - anzahl_tage_bis
      - bezeichnung


derived_columns:
    category_deliveryadherence_nk:
      - bewertung
    count_days_from:
      - anzahl_tage_von
    count_days_to:
      - anzahl_tage_bis
    name:
      - bezeichnung

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