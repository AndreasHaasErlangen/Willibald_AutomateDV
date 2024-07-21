{# template sat_v0 Version: 0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }} 

{%- set yaml_metadata -%}
source_model: "stg_roadshow_bestellung" 
src_pk: 'hk_position_h'
src_hashdiff: 'hd_position_rs_s'
src_payload: 
  - bestellungid
  - gueltigbis
  - kaufdatum
  - kkfirma
  - kreditkarte
  - menge
  - preis
  - produktid
  - rabatt


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