{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: 
    - stg_webshop_produkt
    - stg_webshop_produktkategorie
    - stg_webshop_produktkategorie

src_pk: hk_productcategory_h
src_nk: 'productcategory_bk'
src_ldts: ldts
src_source: rsrc
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.hub(src_pk=metadata_dict["src_pk"],
                   src_nk=metadata_dict["src_nk"], 
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"]) }}
