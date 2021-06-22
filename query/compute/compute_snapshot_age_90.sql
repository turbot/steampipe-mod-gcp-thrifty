select
  self_link as resource,
  case
    when creation_timestamp < (current_date - interval '90' day) then 'alarm'
    else 'ok'
  end as status,
  name || ' created on ' || creation_timestamp || ' (' || date_part('day', now()-creation_timestamp) || ' days).' as reason,
  project
from
  gcp_compute_snapshot;