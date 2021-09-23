## Thrifty SQL Benchmark

Thrifty developers keep a careful eye for SQL DB instances with low connections and low CPU utilization. This benchmark focuses on finding SQL DB instances that have low connections and low CPU utilization.

## Variables

| Variable | Description | Default |
| - | - | - |
| sql_db_instance_min_connections_per_day | The minimum number of client sessions that are connected per day to the DB instance. | 2 connections/day |
| sql_db_instance_min_cpu_utilization | The minimum percentage of computer processing capacity used for a DB instance. | 25% |
