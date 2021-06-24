locals {
  storage_common_tags = merge(local.thrifty_common_tags, {
    service = "storage"
  })
}

benchmark "storage" {
  title         = "Storage Checks"
  description   = "Thrifty developers ensure their storage buckets are multi-regional and have managed lifecycles."
  documentation = file("./controls/docs/storage.md")
  tags          = local.storage_common_tags
  children = [
    control.storage_bucket_multi_regional,
    control.storage_bucket_without_lifecycle_policy,
  ]
}

control "storage_bucket_multi_regional" {
  title         = "Storage buckets should be multi-regional"
  description   = "Storage buckets should be multi-regional to increase availability and geo-redundancy."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when location_type != 'multi-region' then 'alarm'
        else 'ok'
      end as status,
      case
        when location_type != 'multi-region' then title || ' is not multi-regional.'
        else title || ' is multi-regional.'
      end as reason,
       project
    from
      gcp_storage_bucket;
  EOT

  tags = merge(local.storage_common_tags, {
    class = "managed"
  })
}

control "storage_bucket_without_lifecycle_policy" {
  title         = "Storage buckets with no lifecycle policy should be reviewed"
  description   = "Storage buckets should have a lifecycle policy associated for data retention."
  severity      = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when lifecycle_rules is null then 'alarm'
        else 'ok'
      end as status,
      case
        when lifecycle_rules is null then name || ' has no lifecycle policy.'
        else name || ' has lifecycle policy.'
      end as reason,
      project
    from
      gcp_storage_bucket;
  EOT

  tags = merge(local.storage_common_tags, {
    class = "managed"
  })
}
