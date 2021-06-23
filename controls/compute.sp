locals {
  compute_common_tags = merge(local.thrifty_common_tags, {
    service = "compute"
  })
}

benchmark "compute" {
  title         = "Compute Checks"
  description   = "Thrifty developers eliminate unused and under-utilized compute instances."
  #documentation = file("./controls/docs/compute.md") #TODO
  tags          = local.compute_common_tags
  children = [
    control.compute_disk_balanced_persistent,
    control.compute_disk_attached_stopped_instance,
    control.compute_disk_large,
    control.compute_snapshot_age_90,
    control.compute_unattached_disk,
    control.compute_unattached_ip_address,
    control.compute_long_running_instances,
    control.compute_disk_extreme_persistent_disk,
  ]
}

control "compute_disk_balanced_persistent" {
  title       = "SSD persistent (pd-ssd) disks should be replaced with balanced persistent (pd-balanced) disks."
  description = "Balanced persistent (pd-balanced) disks are backed by solid-state drives (SSD). They are an alternative to SSD persistent disks that balance performance and cost. It is recommended to use balanced persistent (pd-balanced) disks instead of SSD persistent(pd-ssd) disks."
  severity    = "low"

  sql = <<-EOT
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
  EOT

  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_disk_attached_stopped_instance" {
  title         = "Disks attached to stopped instances should be reviewed"
  description   = "Instances that are stopped may no longer need any disks attached."
  sql           = query.compute_disk_attached_stopped_instance.sql
  severity      = "low"
  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_disk_large" {
  title         = "Disks with over 100 GB should be resized if too large"
  description   = "Large compute disks are unusual, expensive and should be reviewed."
  sql           = query.compute_disk_large.sql
  severity      = "low"
  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_snapshot_age_90" {
  title         = "Snapshots created over 90 days ago should be deleted if not required"
  description   = "Old snapshots are likely unneeded and costly to maintain."
  sql           = query.compute_snapshot_age_90.sql
  severity      = "low"
  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_unattached_disk" {
  title         = "Unused compute disks should be removed"
  description   = "Unattached compute disks are charged by GCP, they should be removed unless there is a business need to retain them."
  sql           = query.compute_unattached_disk.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}

control "compute_unattached_ip_address" {
  title         = "Unused external IP addresses should be removed"
  description   = "Unattached external IPs are charged, they should be released."
  sql           = query.compute_unattached_ip_address.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}

control "compute_long_running_instances" {
  title         = "Long running compute instances should be reviewed"
  description   = "Instances should ideally be ephemeral and rehydrated frequently, check why these instances have been running for so long."
  sql           = query.compute_long_running_instances.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}

control "compute_disk_extreme_persistent_disk" {
  title         = "SSD persistent (pd-ssd) disks should be replaced with extreme persistent disks"
  description   = "SSD persistent disk should use extreme persistent instead for higher performance."
  sql           = query.compute_disk_extreme_persistent_disk.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}
