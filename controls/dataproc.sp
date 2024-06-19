locals {
  dataproc_common_tags = merge(local.gcp_thrifty_common_tags, {
    service = "GCP/Dataproc"
  })
}

benchmark "dataproc" {
  title         = "Dataproc Checks"
  description   = "Thrifty developers checks Dataproc clusters have autoscaling enabled or not."
  documentation = file("./controls/docs/dataproc.md")
  children = [
    control.dataproc_cluster_without_autoscaling
  ]

  tags = merge(local.dataproc_common_tags, {
    type = "Benchmark"
  })
}

control "dataproc_cluster_without_autoscaling" {
  title       = "Dataproc cluster should use autoscaling policy"
  description = "Dataproc cluster should use autoscaling policy to improve service performance in a cost-efficient way."
  severity      = "low"

  sql = <<-EOQ
    select
      self_link as resource,
      case
        when config -> 'autoscalingConfig' -> 'policyUri' is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when config -> 'autoscalingConfig' -> 'policyUri' is not null then  title || ' autoscaling enabled.'
        else title || ' autoscaling disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      gcp_dataproc_cluster
  EOQ

  tags = merge(local.dataproc_common_tags, {
    class = "managed"
  })
}
