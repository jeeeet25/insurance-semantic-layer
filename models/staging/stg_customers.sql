select
    cast(customer_id as integer)       as customer_id,
    trim(customer_name)                as customer_name,
    upper(trim(state))                 as state,
    cast(age as integer)               as age,
    trim(customer_segment)             as customer_segment
from {{ ref('raw_customers') }}