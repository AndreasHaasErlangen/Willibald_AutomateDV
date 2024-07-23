{%- macro pre_hwm(this,omit_with=false, add_comma_at_end=false) -%}

    {{ adapter.dispatch('pre_hwm', 'datavault_extension')(
                        this=this
                      , omit_with=omit_with
                      , add_comma_at_end=add_comma_at_end
                    ) }}

{%- endmacro -%}

{%- macro snowflake__pre_hwm(this, omit_with, add_comma_at_end) -%}
    {%- if not omit_with -%}WITH{%- endif -%} hwm as
    (
    select hwm_ldts from Willibald_AutomateDV_DEV.dwh_00_meta.META_HWM where object_name = '{{ this }}'
    union all 
    select to_timestamp('01.01.1900','DD.MM.YYYY') hwm_ldts
    )
, hwm_max AS
    (
    select max(hwm_ldts) hwm_max_ts from hwm
    ){%- if add_comma_at_end -%},{%- endif -%}
{%- endmacro -%}