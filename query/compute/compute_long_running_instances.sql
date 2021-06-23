select
  self_link as resource,
  case
    when date_part('day', now() - creation_timestamp) > 90 then 'alarm'
    else 'ok'
  end as status,
  title || ' has been running ' || date_part('day', now() - creation_timestamp) || ' days.' as reason,
  project
from
  gcp_compute_instance
where
  status in ('PROVISIONING', 'STAGING', 'RUNNING','REPAIRING');