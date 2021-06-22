select
  d.self_link as resource,
  case
    when d.users is null then 'info'
    when i.status = 'RUNNING' then 'ok'
    else 'alarm'
  end as status,
  case
    when d.users is null then d.name || ' not attached.'
    when i.status = 'RUNNING' then d.name || ' attached to running instance.'
    else d.name || ' not attached to running instance.'
  end as reason,
  d.project
from
  gcp_compute_disk as d
  left join gcp_compute_instance as i on d.users ?& ARRAY [i.self_link];