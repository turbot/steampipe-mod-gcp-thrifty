select
  self_link as resource,
  case
    when lifecycle_rules is null then 'alarm'
    else 'ok'
  end as status,
  case
    when lifecycle_rules is null then name || ' has no life cycle policy.'
    else name || ' has life cycle policy.'
  end as reason,
  project
from
  gcp_storage_bucket;