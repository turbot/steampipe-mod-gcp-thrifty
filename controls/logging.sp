locals {
  logging_common_tags = merge(local.thrifty_common_tags, {
    service = "logging"
  })
}

benchmark "logging" {
  title         = "Logging Checks"
  description   = "Thrifty developers checks Logging buckets having retention period more than 30 days."
  documentation = file("./controls/docs/logging.md")
  tags          = local.logging_common_tags
  children = [
    control.logging_bucket_higher_retention_period,
  ]
}

control "logging_bucket_higher_retention_period" {
  title         = "Logging buckets with retention period more than 30 days should be reviewed"
  description   = "Setting a longer retention period should be reviewed as it impacts billing."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when retention_days > 30 then 'alarm'
        else 'ok'
      end as status,
      case
        when retention_days > 30 then name || ' is set to ' || retention_days || ' day(s) retention.'
        else name || ' is set to ' || retention_days || ' day(s) retention.'
      end as reason,
      project
    from
      gcp_logging_bucket
    where
      name != '_Required';
  EOT

  tags = merge(local.logging_common_tags, {
    class = "managed"
  })
}