{# template sat_v0 Version: 0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }} 

{%- set yaml_metadata -%}
source_model: "stg_webshop_lieferdienst" 
src_pk: 'hk_deliveryservice_h'
src_hashdiff: 'hd_deliveryservice_ws_s'
src_payload: 
  - email
  - fax
  - hausnummer
  - land
  - name
  - ort
  - plz
  - strasse
  - telefon


src_ldts: ldts
src_source: rsrc

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ automate_dv.sat(src_pk=metadata_dict["src_pk"],
                   src_hashdiff=metadata_dict["src_hashdiff"],
                   src_payload=metadata_dict["src_payload"],
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"])
                   }}    