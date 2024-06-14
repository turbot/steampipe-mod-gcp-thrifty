locals {
  kubernetes_common_tags = merge(local.gcp_thrifty_common_tags, {
    service = "GCP/Kubernetes"
  })
}

benchmark "kubernetes" {
  title         = "Kubernetes Checks"
  description   = "Thrifty developers checks Kubernetes clusters have autoscaling enabled or not."
  documentation = file("./controls/docs/dataproc.md")
  children = [
    control.Kubernetes_cluster_without_vertical_pod_autoscaling
  ]

  tags = merge(local.kubernetes_common_tags, {
    type = "Benchmark"
  })
}

control "Kubernetes_cluster_without_vertical_pod_autoscaling" {
  title       = "Kubernetes cluster should use vertical pod autoscaling policy"
  description = "Kubernetes cluster should use vertical pod autoscaling policy to improve service performance in a cost-efficient way."
  severity      = "low"

  sql = <<-EOQ
    select
      self_link as resource,
      case
        when (vertical_pod_autoscaling -> 'enabled')::bool then 'ok'
        else 'alarm'
      end as status,
      case
        when (vertical_pod_autoscaling -> 'enabled')::bool then  title || ' vertical pod autoscaling enabled.'
        else title || ' vertical pod autoscaling disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      gcp_kubernetes_cluster;
  EOQ

  tags = merge(local.kubernetes_common_tags, {
    class = "managed"
  })
}
