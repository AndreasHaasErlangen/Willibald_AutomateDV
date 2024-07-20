{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: "stg_webshop_wohnort" 
src_pk: "hk_customer_h"
src_hashdiff: 
  source_column: "hd_customer_ws_la_ms"
  alias: "hd_customer_ws_la_ms"  

src_cdk: 
  - 'von'

src_payload: 
  - adresszusatz
  - bis
  - hausnummer
  - land
  - ort
  - plz
  - strasse

src_ldts: ldts
src_source: rsrc
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}


{{ automate_dv.ma_sat(src_pk=metadata_dict['src_pk'],
                      src_cdk=metadata_dict['src_cdk'],
                      src_payload=metadata_dict['src_payload'],
                      src_hashdiff=metadata_dict['src_hashdiff'],
                      src_ldts=metadata_dict['src_ldts'],
                      src_source=metadata_dict['src_source'],
                      source_model=metadata_dict['source_model']) }}   