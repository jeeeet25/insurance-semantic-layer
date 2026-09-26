select
    p.policy_type,
    sum(c.incurred_amount) as total_losses,
    sum(p.earned_premium)  as total_earned_premium_inflated
from {{ ref('fact_claims') }} c
inner join {{ ref('dim_policy') }} p
    on c.policy_id = p.policy_id
group by p.policy_type