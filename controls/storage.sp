locals {
  storage_common_tags = merge(local.gcp_thrifty_common_tags, {
    service = "GCP/Storage"
  })
}

benchmark "storage" {
  title         = "Storage Checks"
  description   = "Thrifty developers ensure their storage buckets have a managed lifecycle."
  documentation = file("./controls/docs/storage.md")
  children = [
    control.storage_bucket_without_lifecycle_policy
  ]

  tags = merge(local.storage_common_tags, {
    type = "Benchmark"
  })
}

control "storage_bucket_without_lifecycle_policy" {
  title         = "Buckets should have lifecycle policies"
  description   = "Buckets should have a lifecycle policy associated for data retention."
  severity      = "low"

  sql = <<-EOQ
    select
      self_link as resource,
      case
        when lifecycle_rules is null then 'alarm'
        else 'ok'
      end as status,
      case
        when lifecycle_rules is null then name || ' has no lifecycle policy.'
        else name || ' has lifecycle policy.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      gcp_storage_bucket;
  EOQ

  tags = merge(local.storage_common_tags, {
    class = "managed"
  })
}
