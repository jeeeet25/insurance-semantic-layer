Select 
    c.claim_id,
    c.policy_id,
    p.customer_id,
    c.claim_number,
    c.claim_date,
    c.claim_category,
    c.claim_status,
    c.claim_amount,
    c.settlement_date,
    c.settlement_amount,
    case
        when c.claim_status = 'Settled' then c.settlement_amount
        when c.claim_status = 'Denied'  then 0
        when c.claim_status = 'Open'    then c.claim_amount
    end as incurred_amount,
    case when c.claim_status = 'Settled' then c.days_to_settlement end as days_to_settlement
from {{ ref('stg_claims') }} c
inner join {{ ref('stg_policies') }} p 
on c.policy_id = p.policy_id