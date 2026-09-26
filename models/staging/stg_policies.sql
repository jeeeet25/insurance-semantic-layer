select
    cast(policy_id as integer)         as policy_id,
    cast(customer_id as integer)       as customer_id,
    trim(policy_number)                as policy_number,
    trim(policy_type)                  as policy_type,
    cast(coverage_amount as decimal(18,2))   as coverage_amount,
    cast(annual_premium as decimal(18,2))    as annual_premium,
    cast(policy_start_date as date)    as policy_start_date,
    trim(policy_status)                as policy_status
from {{ ref('raw_policies') }}