{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set source_model = 'stg_misc_kategorie_termintreue'           -%}
{%- set src_pk = 'category_deliveryadherence_nk'                          -%}
{%- set src_extra_columns = ['count_days_from', 'count_days_to', 'name'] -%}

{{ automate_dv.ref_table(src_pk=src_pk, 
                         src_extra_columns=src_extra_columns,
                         source_model=source_model) }}

