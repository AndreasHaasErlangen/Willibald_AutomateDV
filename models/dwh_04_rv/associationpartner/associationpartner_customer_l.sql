{# template link Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: 
  - stg_webshop_vereinspartner
src_pk: hk_associationpartner_customer_l 
src_fk: 
  - 'hk_customer_h'
  - 'hk_associationpartner_h'
src_ldts: ldts
src_source: rsrc
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.link(src_pk=metadata_dict["src_pk"],
                    src_fk=metadata_dict["src_fk"], 
                    src_ldts=metadata_dict["src_ldts"],
                    src_source=metadata_dict["src_source"], 
                    source_model=metadata_dict["source_model"]) }}