variable "sql_db_instance_min_connections_per_day" {
  type        = number
  description = "The minimum number of client sessions that are connected per day to the DB instance."
}

variable "sql_db_instance_min_cpu_utilization" {
  type        = number
  description = "The minimum percentage of computer processing capacity used for a DB instance."
}

locals {
  sql_common_tags = merge(local.thrifty_common_tags, {
    service = "sql"
  })
}

benchmark "sql" {
  title         = "SQL Checks"
  description   = "Thrifty developers eliminate unused and under-utilized SQL DB instances."
  documentation = file("./controls/docs/sql.md")
  tags          = local.sql_common_tags
  children = [
    control.sql_db_instance_low_connection_count,
    control.sql_db_instance_low_utilization,
  ]
}

control "sql_db_instance_low_connection_count" {
  title         = "SQL DB instances with less than ${var.sql_db_instance_min_connections_per_day} connections per day should be reviewed"
  description   = "DB instances having less usage in last 30 days should be reviewed."
  severity      = "low"

  sql = <<-EOT
    with sql_db_instance_usage as (
      select
        instance_id,
        round(sum(maximum) / count(maximum)) as avg_max,
        count(maximum) as days
      from
        gcp_sql_database_instance_metric_connections_daily
      where
        date_part('day', now() - timestamp) <= 30
      group by
        instance_id
    )
    select
      i.self_link as resource,
      case
        when avg_max is null then 'error'
        when avg_max = 0 then 'alarm'
        when avg_max < $1 then 'info'
        else 'ok'
      end as status,
      case
        when avg_max is null then 'Logging metrics not available for ' || title || '.'
        when avg_max = 0 then title || ' has not been connected to in the last ' || days || ' days.'
        else title || ' is averaging ' || avg_max || ' max connections/day in the last ' || days || ' days.'
      end as reason,
      project
    from
      gcp_sql_database_instance as i
      left join sql_db_instance_usage as u on i.project || ':' || i.name = u.instance_id;
  EOT

  param "sql_db_instance_min_connections_per_day" {
    default = var.sql_db_instance_min_connections_per_day
  }

  tags = merge(local.sql_common_tags, {
    class = "unused"
  })
}

control "sql_db_instance_low_utilization" {
  title         = "SQL DB instance having less than ${var.sql_db_instance_min_cpu_utilization}% utilization should be reviewed"
  description   = "DB instances may be oversized for their usage."
  severity      = "low"

  sql = <<-EOT
    with sql_db_instance_usage as (
      select
        instance_id,
        round(cast(sum(maximum) / count(maximum) as numeric), 1) as avg_max,
        count(maximum) as days
      from
        gcp_sql_database_instance_metric_cpu_utilization_daily
      where
        date_part('day', now() - timestamp) <= 30
      group by
        instance_id
    )
    select
      i.self_link as resource,
      case
        when avg_max is null then 'error'
        when avg_max <= $1 then 'alarm'
        when avg_max <= 50 then 'info'
        else 'ok'
      end as status,
      case
        when avg_max is null then 'Logging metrics not available for ' || title || '.'
        else title || ' is averaging ' || avg_max || '% max utilization over the last ' || days || ' days.'
      end as reason,
      i.project
    from
      gcp_sql_database_instance as i
      left join sql_db_instance_usage as u on i.project || ':' || i.name = u.instance_id
  EOT

  param "sql_db_instance_min_cpu_utilization" {
    default = var.sql_db_instance_min_cpu_utilization
  }

  tags = merge(local.sql_common_tags, {
    class = "managed"
  })
}