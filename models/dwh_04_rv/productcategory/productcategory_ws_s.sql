{# template sat_v0 Version: 0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }} 

{%- set yaml_metadata -%}
source_model: "stg_webshop_produktkategorie" 
src_pk: 'hk_productcategory_h'
src_hashdiff: 'hd_productcategory_ws_s'
src_payload: 
  - name


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