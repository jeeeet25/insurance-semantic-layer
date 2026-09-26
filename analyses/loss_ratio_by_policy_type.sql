with premiums as (
    select
        policy_type,
        sum(earned_premium) as total_earned_premium
    from {{ ref('dim_policy') }}
    group by policy_type
),

losses as (
    select
        p.policy_type,
        sum(c.incurred_amount) as total_losses
    from {{ ref('fact_claims') }} c
    inner join {{ ref('dim_policy') }} p
        on c.policy_id = p.policy_id
    group by p.policy_type
)

select
    pr.policy_type,
    coalesce(l.total_losses, 0)     as total_losses,
    pr.total_earned_premium,
    round(coalesce(l.total_losses, 0) / nullif(pr.total_earned_premium, 0), 2) as loss_ratio
from premiums pr
left join losses l
    on pr.policy_type = l.policy_type
order by pr.policy_type