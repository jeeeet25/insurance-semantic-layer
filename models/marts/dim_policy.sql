with last_txn as (
    select
        policy_id,
        max(transaction_date) as last_txn_date
    from {{ ref('stg_transactions') }}
    where transaction_status = 'Completed'
    group by policy_id
),

policy_exposure as (
    select
        p.*,
        case
            when p.policy_status = 'Lapsed' then t.last_txn_date
            else cast('{{ var("as_of_date") }}' as date)
        end                                   as exposure_end_date,
        p.policy_status = 'Active'            as is_active
    from {{ ref('stg_policies') }} p
    left join last_txn t
        on p.policy_id = t.policy_id
)

select
    *,
    round(date_diff('day', policy_start_date, exposure_end_date) / 365.25, 4)
        as years_in_force,
    round(annual_premium * date_diff('day', policy_start_date, exposure_end_date) / 365.25, 2)
        as earned_premium
from policy_exposure