select
    cast(claim_id as integer)                  as claim_id,
    cast(policy_id as integer)                 as policy_id,
    trim(claim_number)                         as claim_number,
    cast(claim_date as date)                   as claim_date,
    trim(claim_category)                       as claim_category,
    cast(claim_amount as decimal(18,2))        as claim_amount,
    trim(claim_status)                         as claim_status,
    cast(settlement_date as date)              as settlement_date,
    cast(settlement_amount as decimal(18,2))   as settlement_amount,
    cast(days_to_settlement as integer)        as days_to_settlement
from {{ ref('raw_claims') }}