select
  self_link as resource,
  case
    when size_gb <= 100 then 'ok'
    else 'alarm'
  end as status,
  title || ' is ' || size_gb || 'GB.' as reason,
  project
from
  gcp_compute_disk;