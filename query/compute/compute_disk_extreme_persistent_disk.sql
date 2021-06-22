select
  self_link as resource,
  case
    when type_name = 'pd-ssd' then 'alarm'
    when type_name = 'pd-extreme' then 'ok'
    else 'skip'
  end as status,
  title || ' type is ' || type_name || '.' as reason,
  project
from
  gcp_compute_disk;