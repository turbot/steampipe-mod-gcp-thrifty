select
  self_link as resource,
  case
    when status != 'IN_USE' then 'alarm'
    else 'ok'
  end as status,
  case
    when status != 'IN_USE' then address || ' not attached.'
    else address || ' attached.'
  end as reason,
  project
from
  gcp_compute_address;