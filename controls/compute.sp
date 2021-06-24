locals {
  compute_common_tags = merge(local.thrifty_common_tags, {
    service = "compute"
  })
}

benchmark "compute" {
  title         = "Compute Checks"
  description   = "Thrifty developers eliminate unused and under-utilized Compute resources."
  documentation = file("./controls/docs/compute.md")
  tags          = local.compute_common_tags
  children = [
    control.compute_address_unattached,
    control.compute_disk_attached_stopped_instance,
    control.compute_disk_large,
    control.compute_disk_unattached,
    control.compute_instance_large,
    control.compute_instance_long_running,
    control.compute_snapshot_age_90,
  ]
}

control "compute_address_unattached" {
  title         = "Unused external IP addresses should be removed"
  description   = "Unattached external IPs cost money and should be released."
  severity      = "low"

  sql = <<-EOT
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
  EOT

  tags = merge(local.storage_common_tags, {
    class = "unused"
  })
}

control "compute_disk_attached_stopped_instance" {
  title         = "Disks attached to stopped instances should be reviewed"
  description   = "Instances that are stopped may no longer need any disks attached."
  severity      = "low"

  sql = <<-EOT
    select
      d.self_link as resource,
      case
        when d.users is null then 'info'
        when i.status = 'RUNNING' then 'ok'
        else 'info'
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
  EOT

  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_disk_large" {
  title         = "Disks with over 100 GB should be resized if too large"
  description   = "Large compute disks are unusual, expensive and should be reviewed."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when size_gb <= 100 then 'ok'
        else 'info'
      end as status,
      title || ' has ' || size_gb || ' GB.' as reason,
      project
    from
      gcp_compute_disk;
  EOT

  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_disk_unattached" {
  title         = "Unused disks should be removed"
  description   = "Unattached disks cost money and should be removed unless there is a business need to retain them."
  severity      = "low"

  sql = <<-EOT
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
  EOT

  tags = merge(local.storage_common_tags, {
    class = "unused"
  })
}

control "compute_instance_large" {
  title         = "Instances with more then 32 vCPU should be reviewed"
  description   = "Large compute instances are unusual, expensive and should be reviewed."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when status not in ('RUNNING', 'PROVISIONING', 'STAGING', 'REPAIRING') then 'info'
        when machine_type_name like any (ARRAY ['%-micro','%-small', '%-medium','%-2','%-4', '%-8','%-16','%-30','%-32','%-1g','%-2g']) then 'ok'
        else 'info'
      end as status,
      title || ' has type ' || machine_type_name || ' and is ' || status || '.' as reason,
      project
    from
      gcp_compute_instance;
  EOT

  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_instance_long_running" {
  title         = "Long running instances should be reviewed"
  description   = "Instances should ideally be ephemeral and rehydrated frequently, check why these instances have been running for so long."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when date_part('day', now() - creation_timestamp) > 90 then 'info'
        else 'ok'
      end as status,
      title || ' has been running for ' || date_part('day', now() - creation_timestamp) || ' day(s).' as reason,
      project
    from
      gcp_compute_instance
    where
      status in ('PROVISIONING', 'STAGING', 'RUNNING','REPAIRING');
  EOT

  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}

control "compute_snapshot_age_90" {
  title         = "Snapshots created over 90 days ago should be deleted if not required"
  description   = "Old snapshots are likely unneeded and costly to maintain."
  severity      = "low"

  sql = <<-EOT
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
  EOT

  tags = merge(local.compute_common_tags, {
    class = "unused"
  })
}
