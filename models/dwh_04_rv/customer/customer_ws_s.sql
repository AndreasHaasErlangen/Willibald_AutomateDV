{{ config(materialized='incremental') }} 

{%- set yaml_metadata -%}
source_model: "stg_webshop_kunde" 
src_pk: 'hk_customer_h'
src_hashdiff: 
  source_column: "hd_customer_ws_s"
  alias: "hd_customer_ws_s"  
src_payload: 
  - email
  - geburtsdatum
  - geschlecht
  - gueltigbis
  - kkfirma
  - kreditkarte
  - mobil
  - name
  - telefon
  - vorname

src_ldts: ldts
src_source: rsrc
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.sat(src_pk=metadata_dict["src_pk"],
                   src_hashdiff=metadata_dict["src_hashdiff"],
                   src_payload=metadata_dict["src_payload"],
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"])
                   }}        