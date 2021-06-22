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
    control.compute_disk_age_90,
    control.compute_unattached_disk,
    control.compute_unattached_ip_address,
    control.compute_long_running_instances,
    control.compute_disk_extreme_persistent_disk,
  ]
}

control "compute_disk_balanced_persistent" {
  title         = "SSD persistent (pd-ssd) disks should be replaced with balanced persistent (pd-balanced) disks."
  description   = "Balanced persistent (pd-balanced) disks are backed by solid-state drives (SSD). They are an alternative to SSD persistent disks that balance performance and cost. It is recommended to use balanced persistent (pd-balanced) disks instead of SSD persistent (pd-ssd) disks "
  sql           = query.compute_disk_balanced_persistent.sql
  severity      = "low"
  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_disk_attached_stopped_instance" {
  title         = "Disks attached to stopped instances should be reviewed"
  description   = "Disks attached to stopped instances should be reviewed"
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

control "compute_disk_age_90" {
  title         = "Snapshots created over 90 days ago should be deleted if not required"
  description   = "Which disks are only attached to stopped compute instances?"
  sql           = query.compute_snapshot_age_90.sql
  severity      = "low"
  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_unattached_disk" {
  title         = "Unused compute disks should be removed"
  description   = "Are there any unattached compute disks?."
  sql           = query.compute_unattached_disk.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}

control "compute_unattached_ip_address" {
  title         = "Unused external IP addresses should be removed"
  description   = "Are there any unattached external IP addresses?."
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
  description   = "Still using SSD persistent ? Should use extreme persistent instead for higher performance."
  sql           = query.compute_disk_extreme_persistent_disk.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}