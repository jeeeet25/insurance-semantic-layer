--This catches claims larger than the policy's coverage.

{{ config(severity='warn') }}

select
    c.claim_id,
    c.claim_number,
    c.claim_amount,
    p.coverage_amount,
    p.policy_number
from {{ ref('fact_claims') }} c
inner join {{ ref('dim_policy')  }} p 
on c.policy_id = p.policy_id
where c.claim_amount > p.coverage_amount