## Thrifty BigQuery Benchmark

Thrifty developers archive BigQuery tables with stale data. This benchmark
focuses on finding tables where the data has not changed recently.

### Variables

| Variable | Description | Default |
| - | - | - |
| bigquery_table_stale_data_max_days | The maximum number of days table data can be unchanged before it is considered stale. | 90 days |
