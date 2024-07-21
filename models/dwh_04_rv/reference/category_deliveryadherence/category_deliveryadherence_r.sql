{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set source_model = 'stg_misc_kategorie_termintreue'           -%}
{%- set src_pk = 'category_deliveryadherence_nk'                          -%}

{{ automate_dv.ref_table(src_pk=src_pk, 
                         source_model=source_model) }}


