select
    count(*) as active_policies
from {{ ref('dim_policy') }}
where is_active