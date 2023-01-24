variable "logging_bucket_max_retention_days" {
  type        = number
  description = "The maximum number of days allowed for bucket log retention period."
  default     = 30
}

locals {
  logging_common_tags = merge(local.gcp_thrifty_common_tags, {
    service = "GCP/Logging"
  })
}

benchmark "logging" {
  title         = "Logging Checks"
  description   = "Thrifty developers checks Logging buckets having retention period more than 30 days."
  documentation = file("./controls/docs/logging.md")
  children = [
    control.logging_bucket_higher_retention_period
  ]

  tags = merge(local.logging_common_tags, {
    type = "Benchmark"
  })
}

control "logging_bucket_higher_retention_period" {
  title         = "Logging buckets with long retention period should be reviewed"
  description   = "Setting a longer retention period should be reviewed as it impacts billing."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when retention_days > $1 then 'alarm'
        else 'ok'
      end as status,
      title || ' retention period set to ' || retention_days || ' day(s).' as reason
      ${local.common_dimensions_sql}
    from
      gcp_logging_bucket
    where
      name != '_Required';
  EOT

  param "logging_bucket_max_retention_days" {
    description = "The maximum number of days allowed for bucket log retention period."
    default     = var.logging_bucket_max_retention_days
  }

  tags = merge(local.logging_common_tags, {
    class = "managed"
  })
}
