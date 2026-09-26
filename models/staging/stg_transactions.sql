select
    cast(transaction_id as integer)             as transaction_id,
    cast(policy_id as integer)                  as policy_id,
    cast(transaction_date as date)              as transaction_date,
    trim(transaction_type)                      as transaction_type,
    cast(transaction_amount as decimal(18,2))   as transaction_amount,
    trim(transaction_status)                    as transaction_status
from {{ ref('raw_transactions') }}