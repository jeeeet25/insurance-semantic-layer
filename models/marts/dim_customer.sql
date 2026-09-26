select
    customer_id,
    customer_name,
    state,
    age,
    case
        when age is null then 'Unknown'
        when age < 35    then 'Under 35'
        when age < 50    then '35-49'
        else '50+'
    end as age_band,
    customer_segment
from {{ ref('stg_customers') }}