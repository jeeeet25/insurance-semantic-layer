select
    avg(days_to_settlement) as Average_days_to_settlement
from {{ ref('fact_claims') }}