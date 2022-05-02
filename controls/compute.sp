variable "compute_disk_max_size_gb" {
  type        = number
  description = "The maximum size (GB) allowed for disks."
  default     = 100
}

variable "compute_disk_avg_read_write_ops_low" {
  type        = number
  description = "The number of average read/write ops required for disks to be considered infrequently used. This value should be lower than compute_disk_avg_read_write_ops_high."
  default     = 100
}

variable "compute_disk_avg_read_write_ops_high" {
  type        = number
  description = "The number of average read/write ops required for disks to be considered frequently used. This value should be higher than compute_disk_avg_read_write_ops_low."
  default     = 500
}

variable "compute_instance_allowed_types" {
  type        = list(string)
  description = "A list of allowed instance types. PostgreSQL wildcards are supported."
  default     = ["%-micro", "%-small", "%-medium", "%-2", "%-4", "%-8", "%-16", "%-30", "%-32", "%-1g", "%-2g"]
}

variable "compute_running_instance_age_max_days" {
  type        = number
  description = "The maximum number of days instances are allowed to run."
  default     = 90
}

variable "compute_instance_avg_cpu_utilization_low" {
  type        = number
  description = "The average CPU utilization required for instances to be considered infrequently used. This value should be lower than compute_instance_avg_cpu_utilization_high."
  default     = 20
}

variable "compute_instance_avg_cpu_utilization_high" {
  type        = number
  description = "The average CPU utilization required for instances to be considered frequently used. This value should be higher than compute_instance_avg_cpu_utilization_low."
  default     = 35
}

variable "compute_snapshot_age_max_days" {
  type        = number
  description = "The maximum number of days snapshots can be retained."
  default     = 90
}

locals {
  compute_common_tags = merge(local.gcp_thrifty_common_tags, {
    service = "GCP/Compute"
  })
}

benchmark "compute" {
  title         = "Compute Checks"
  description   = "Thrifty developers eliminate unused and under-utilized Compute resources."
  documentation = file("./controls/docs/compute.md")
  children = [
    control.compute_address_unattached,
    control.compute_disk_attached_stopped_instance,
    control.compute_disk_large,
    control.compute_disk_low_usage,
    control.compute_disk_unattached,
    control.compute_instance_large,
    control.compute_instance_long_running,
    control.compute_instance_low_utilization,
    control.compute_snapshot_max_age
  ]

  tags = merge(local.compute_common_tags, {
    type = "Benchmark"
  })
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
        when d.users is null then 'skip'
        when i.status = 'RUNNING' then 'ok'
        else 'info'
      end as status,
      case
        when d.users is null then d.name || ' not attached to instance.'
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
  title         = "Disks should be resized if too large"
  description   = "Large compute disks are unusual, expensive and should be reviewed."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when size_gb <= $1 then 'ok'
        else 'info'
      end as status,
      title || ' has ' || size_gb || ' GB.' as reason,
      project
    from
      gcp_compute_disk;
  EOT

  param "compute_disk_max_size_gb" {
    description = "The maximum size (GB) allowed for disks."
    default     = var.compute_disk_max_size_gb
  }

  tags = merge(local.compute_common_tags, {
    class = "deprecated"
  })
}

control "compute_disk_low_usage" {
  title         = "Compute disks with low usage should be reviewed"
  description   = "Disks that are unused should be archived and deleted."
  severity      = "low"

  sql = <<-EOT
    with disk_usage as (
      select
        name,
        round(avg(max)) as avg_max,
        count(max) as days
      from
        (
          select
            name,
            cast(maximum as numeric) as max
          from
            gcp_compute_disk_metric_read_ops_daily
          where
            date_part('day', now() - timestamp) <= 30
          union all
          select
            name,
            cast(maximum as numeric) as max
          from
            gcp_compute_disk_metric_write_ops_daily
          where
            date_part('day', now() - timestamp) <= 30
        ) as read_and_write_ops
      group by
        name
    )
    select
      name as resource,
      case
        when avg_max <= $1 then 'alarm'
        when avg_max <= $2 then 'info'
        else 'ok'
      end as status,
      name || ' is averaging ' || avg_max || ' read and write ops over the last ' || days / 2 || ' days.' as reason
    from
      disk_usage;
  EOT

  param "compute_disk_avg_read_write_ops_low" {
    description = "The number of average read/write ops required for disks to be considered infrequently used. This value should be lower than compute_disk_avg_read_write_ops_high."
    default     = var.compute_disk_avg_read_write_ops_low
  }

  param "compute_disk_avg_read_write_ops_high" {
    description = "The number of average read/write ops required for disks to be considered frequently used. This value should be higher than compute_disk_avg_read_write_ops_low."
    default     = var.compute_disk_avg_read_write_ops_high
  }

  tags = merge(local.compute_common_tags, {
    class = "unused"
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
        when machine_type_name like any ($1) then 'ok'
        else 'info'
      end as status,
      title || ' has type ' || machine_type_name || ' and is ' || status || '.' as reason,
      project
    from
      gcp_compute_instance;
  EOT

  param "compute_instance_allowed_types" {
    description = "A list of allowed instance types. PostgreSQL wildcards are supported."
    default     = var.compute_instance_allowed_types
  }

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
        when date_part('day', now() - creation_timestamp) > $1 then 'info'
        else 'ok'
      end as status,
      title || ' has been running for ' || date_part('day', now() - creation_timestamp) || ' day(s).' as reason,
      project
    from
      gcp_compute_instance
    where
      status in ('PROVISIONING', 'STAGING', 'RUNNING','REPAIRING');
  EOT

  param "compute_running_instance_age_max_days" {
    description = "The maximum number of days instances are allowed to run."
    default     = var.compute_running_instance_age_max_days
  }

  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}

control "compute_instance_low_utilization" {
  title         = "Compute instances with low CPU utilization should be reviewed"
  description   = "Resize or eliminate under utilized instances."
  severity      = "low"

  sql = <<-EOT
    with compute_instance_utilization as (
      select
        name,
        round(cast(sum(maximum) / count(maximum) as numeric), 1) as avg_max,
        count(maximum) as days
      from
        gcp_compute_instance_metric_cpu_utilization_daily
      where
        date_part('day', now() - timestamp :: timestamp) <= 30
      group by
        name
    )
    select
      self_link as resource,
      case
        when avg_max is null then 'error'
        when avg_max < $1 then 'alarm'
        when avg_max < $2 then 'info'
        else 'ok'
      end as status,
      case
        when avg_max is null then 'Logging metrics not available for ' || title || '.'
        else title || ' averaging ' || avg_max || '% max utilization over the last ' || days || ' days.'
      end as reason,
      project
    from
      gcp_compute_instance as i
      left join compute_instance_utilization as u on u.name = i.name;
  EOT

  param "compute_instance_avg_cpu_utilization_low" {
    description = "The average CPU utilization required for instances to be considered infrequently used. This value should be lower than compute_instance_avg_cpu_utilization_high."
    default     = var.compute_instance_avg_cpu_utilization_low
  }

  param "compute_instance_avg_cpu_utilization_high" {
    description = "The average CPU utilization required for instances to be considered frequently used. This value should be higher than compute_instance_avg_cpu_utilization_low."
    default     = var.compute_instance_avg_cpu_utilization_high
  }

  tags = merge(local.compute_common_tags, {
    class = "unused"
  })
}

control "compute_snapshot_max_age" {
  title         = "Old snapshots should be deleted if not required"
  description   = "Old snapshots are likely unneeded and costly to maintain."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when creation_timestamp < (current_date - ($1 || ' days')::interval) then 'alarm'
        else 'ok'
      end as status,
      name || ' created on ' || creation_timestamp || ' (' || date_part('day', now()-creation_timestamp) || ' days).' as reason,
      project
    from
      gcp_compute_snapshot;
  EOT

  param "compute_snapshot_age_max_days" {
    description = "The maximum number of days snapshots can be retained."
    default     = var.compute_snapshot_age_max_days
  }

  tags = merge(local.compute_common_tags, {
    class = "unused"
  })
}
