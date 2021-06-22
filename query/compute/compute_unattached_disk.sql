select
  self_link as resource,
  case
    when users is null then 'alarm'
    else 'ok'
  end as status,
  case
    when users is null then title || ' has no attachments.'
    else title || ' has attachments.'
  end as reason,
  project
from
  gcp_compute_disk;