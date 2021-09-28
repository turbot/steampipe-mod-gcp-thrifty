## Thrifty Compute Benchmark

Thrifty developers eliminate their unused and under-utilized compute instances.
This benchmark focuses on finding resources that have not been restarted
recently, are using very large instance sizes, have old snapshots, have low utilization and have
unused disks and IP addresses.

### Variables

| Variable | Description | Default |
| - | - | - |
| compute_disk_max_size_gb | The maximum size (GB) allowed for disks. | 100 GB |
| compute_disk_avg_read_write_ops_low | The number of average read/write ops required for disks to be considered infrequently used. This value should be lower than `compute_disk_avg_read_write_ops_high`. | 100 |
| compute_disk_avg_read_write_ops_high | The number of average read/write ops required for disks to be considered frequently used. This value should be higher than `compute_disk_avg_read_write_ops_low`. | 500 |
| compute_instance_allowed_types | A list of allowed instance types. PostgreSQL wildcards are supported. | ["%-micro", "%-small", "%-medium", "%-2", "%-4", "%-8", "%-16", "%-30", "%-32", "%-1g", "%-2g"] |
| compute_running_instance_age_max_days | The maximum number of days instances are allowed to run. | 90 days |
| compute_instance_avg_cpu_utilization_low | The average CPU utilization required for instances to be considered infrequently used. This value should be lower than compute_instance_avg_cpu_utilization_high. | 20% |
| compute_instance_avg_cpu_utilization_high | The average CPU utilization required for instances to be considered frequently used. This value should be higher than compute_instance_avg_cpu_utilization_low. | 35% |
| compute_snapshot_age_max_days | The maximum number of days snapshots can be retained. | 90 days |
