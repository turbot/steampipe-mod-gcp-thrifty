locals {
  storage_common_tags = merge(local.thrifty_common_tags, {
    service = "storage"
  })
}

benchmark "storage" {
  title         = "Storage Checks"
  description   = "Thrifty developers ensure their storage buckets are multi regional and have managed life-cycles."
  #documentation = file("./controls/docs/storage.md") #TODO
  tags          = local.storage_common_tags
  children = [
    control.storage_bucket_without_lifecycle_policy,
    control.storage_bucket_multi_regional,
  ]
}

control "storage_bucket_without_lifecycle_policy" {
  title         = "Storage buckets with no lifecycle policy should be reviewed"
  description   = "Storage Buckets should have a life cycle policy associated for data retention."
  sql           = query.storage_bucket_without_lifecycle_policy.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}

control "storage_bucket_multi_regional" {
  title         = "Storage bucket should be multi regional"
  description   = "Storage bucket should be multi regional to Minimize storage bucket deduplication."
  sql           = query.storage_bucket_multi_regional.sql
  severity      = "low"
  tags = merge(local.storage_common_tags, {
    class = "deprecated"
  })
}