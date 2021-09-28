## Thrifty SQL Benchmark

Thrifty developers keep a careful eye for SQL DB instances with low connections and low CPU utilization. This benchmark focuses on finding SQL DB instances that have low connections and low CPU utilization.

## Variables

| Variable | Description | Default |
| - | - | - |
| sql_db_instance_avg_connections | The minimum number of average connections per day required for DB instances to be considered in-use. | 2 connections/day |
| sql_db_instance_avg_cpu_utilization_low | The average CPU utilization required for DB instances to be considered infrequently used. This value should be lower than the value for `sql_db_instance_avg_cpu_utilization_high`. | 25% |
| sql_db_instance_avg_cpu_utilization_high | The average CPU utilization required for DB instances to be considered frequently used. This value should be higher than the value for `sql_db_instance_avg_cpu_utilization_low`. | 50% |
