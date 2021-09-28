variable "sql_db_instance_avg_connections" {
  type        = number
  description = "The minimum number of average connections per day required for DB instances to be considered in-use."
}

variable "sql_db_instance_avg_cpu_utilization_low" {
  type        = number
  description = "The average CPU utilization required for DB instances to be considered infrequently used. This value should be lower than sql_db_instance_avg_cpu_utilization_high."
}

variable "sql_db_instance_avg_cpu_utilization_high" {
  type        = number
  description = "The average CPU utilization required for DB instances to be considered frequently used. This value should be higher than sql_db_instance_avg_cpu_utilization_low."
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
  title         = "SQL DB instances with a low number connections per day should be reviewed"
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

  param "sql_db_instance_avg_connections" {
    description = "The minimum number of average connections per day required for DB instances to be considered in-use."
    default     = var.sql_db_instance_avg_connections
  }

  tags = merge(local.sql_common_tags, {
    class = "unused"
  })
}

control "sql_db_instance_low_utilization" {
  title         = "SQL DB instance having low CPU utilization should be reviewed"
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
        when avg_max <= $2 then 'info'
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

  param "sql_db_instance_avg_cpu_utilization_low" {
    description = "The average CPU utilization required for DB instances to be considered infrequently used. This value should be lower than sql_db_instance_avg_cpu_utilization_high."
    default     = var.sql_db_instance_avg_cpu_utilization_low
  }

  param "sql_db_instance_avg_cpu_utilization_high" {
    description = "The average CPU utilization required for DB instances to be considered frequently used. This value should be higher than sql_db_instance_avg_cpu_utilization_low."
    default     = var.sql_db_instance_avg_cpu_utilization_high
  }

  tags = merge(local.sql_common_tags, {
    class = "managed"
  })
}
