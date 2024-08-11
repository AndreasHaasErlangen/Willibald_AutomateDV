{{ config(materialized='incremental') }} 
{%- set yaml_metadata -%}
source_model: "load_webshop_kunde" 
src_pk: 'kundeid'
columns_to_exclude:
  - LDTS
  - RSRC
  - EDTS_IN
  - RAW_DATA
  - ROW_NUMBER
  - IS_LDTS_TYPE_OK
  - IS_EDTS_IN_TYPE_OK
  - IS_ROW_NUMBER_TYPE_OK
  - IS_GEBURTSDATUM_TYPE_OK
  - IS_DUB_CHECK_OK
  - IS_KUNDEID_KEY_CHECK_OK
  - IS_CHECK_OK
  - CHK_ALL_MSG

src_payload: 
  - kundeid
  - vereinspartnerid  
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

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ psa(source_model=metadata_dict["source_model"], 
                src_pk=metadata_dict["src_pk"],
                columns_to_exclude=metadata_dict["columns_to_exclude"],
                src_payload=metadata_dict["src_payload"],
                src_ldts=metadata_dict["src_ldts"])
                   }}    