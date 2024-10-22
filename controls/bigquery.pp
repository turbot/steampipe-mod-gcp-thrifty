variable "bigquery_table_stale_data_max_days" {
  type        = number
  description = "The maximum number of days table data can be unchanged before it is considered stale."
  default     = 90
}

locals {
  bigquery_common_tags = merge(local.gcp_thrifty_common_tags, {
    service = "GCP/BigQuery"
  })
}

benchmark "bigquery" {
  title         = "BigQuery Checks"
  description   = "Thrifty developers delete BigQuery tables with stale data."
  documentation = file("./controls/docs/bigquery.md")
  children = [
    control.bigquery_table_stale_data
  ]

  tags = merge(local.bigquery_common_tags, {
    type = "Benchmark"
  })
}

control "bigquery_table_stale_data" {
  title       = "Tables with stale data should be reviewed"
  description = "If the data has not changed recently and has become stale, the table should be reviewed."
  severity    = "low"

  sql = <<-EOQ
    select
      self_link as resource,
      case
        when date_part('day', now() - (last_modified_time :: timestamptz)) > $1 then 'info'
        else 'ok'
      end as status,
      title || ' was changed ' || date_part('day', now() - (last_modified_time :: timestamptz)) || ' days ago.'
      as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      gcp_bigquery_table;
  EOQ

  param "bigquery_table_stale_data_max_days" {
    description = "The maximum number of days table data can be unchanged before it is considered stale."
    default     = var.bigquery_table_stale_data_max_days
  }

  tags = merge(local.bigquery_common_tags, {
    class = "deprecated"
  })
}
