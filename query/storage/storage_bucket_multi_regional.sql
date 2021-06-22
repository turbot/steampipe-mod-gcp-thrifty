select
  self_link as resource,
  case
    when location_type != 'multi-region' then 'alarm'
    else 'ok'
  end as status,
  case
    when location_type != 'multi-region' then title || ' is not multi-regional.'
    else title || ' is multi-regional.'
  end as reason,
  project
from
  gcp_storage_bucket;