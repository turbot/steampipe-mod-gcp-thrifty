select
  self_link as resource,
  case
    when type_name = 'pd-ssd' then 'alarm'
    when type_name = 'pd-balanced' then 'ok'
    else 'skip'
  end as status,
  title || ' is ' || type_name || '.' as reason,
  project
from
  gcp_compute_disk;