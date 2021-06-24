## Thrifty BigQuery Benchmark

Thrifty developers archive BigQuery tables with stale data. This benchmark
focuses on finding tables where the data has not changed recently.

### Default Thresholds

- [Stale table data threshold (90 Days)](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/controls/bigquery.sp#L26)
