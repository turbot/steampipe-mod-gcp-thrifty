## Thrifty SQL Benchmark

Thrifty developers keep a careful eye for SQL DB instances with low connections and low CPU utilization. This benchmark focuses on finding SQL DB instances that have low connections and low CPU utilization.

### Default Thresholds

- [Low connection threshold (2 Min connections per day)](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/controls/sql.sp#L41)
- [Very low utilization threshold (< 25%)](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/controls/sql.sp#L82)