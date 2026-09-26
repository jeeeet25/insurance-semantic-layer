-- this is catches claims dated before their policy started

{{ config(severity='warn') }}

select
    c.claim_id,
    c.claim_number,
    c.claim_date,
    p.policy_start_date
from {{ ref('fact_claims') }} c 
inner join {{ ref('dim_policy') }} p
on c.policy_id = p.policy_id
where c.claim_date < p.policy_start_date
 