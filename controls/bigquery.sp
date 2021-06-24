locals {
  bigquery_common_tags = merge(local.thrifty_common_tags, {
    service = "bigquery"
  })
}

benchmark "bigquery" {
  title         = "BigQuery Checks"
  description   = "Thrifty developers delete BigQuery tables with stale data."
  documentation = file("./controls/docs/bigquery.md")
  tags          = local.bigquery_common_tags
  children = [
    control.bigquery_table_stale_data,
  ]
}

control "bigquery_table_stale_data" {
  title       = "BigQuery tables with stale data should be reviewed"
  description = "If the data has not changed in 90 days, the table should be reviewed."
  severity    = "low"

  sql = <<-EOT
    select
      self_link as resource,
      case
        when date_part('day', now() -(last_modified_time :: timestamptz)) > 90 then 'alarm'
        else 'ok'
      end as status,
      title || ' was changed ' || date_part('day', now() -(last_modified_time :: timestamptz)) || ' days ago.'
      as reason,
      project
    from
      gcp_bigquery_table;
  EOT

  tags = merge(local.bigquery_common_tags, {
    class = "deprecated"
  })
}
