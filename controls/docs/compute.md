## Thrifty Compute Benchmark

Thrifty developers eliminate their unused and under-utilized compute instances.
This benchmark focuses on finding resources that have not been restarted
recently, are using very large instance sizes, have old snapshots, have low utilization and have
unused disks and IP addresses.

### Variables

| Variable | Description | Default |
| - | - | - |
| compute_disk_max_size_gb | The maximum size in GB allowed for disks. | 100 GB |
| compute_instance_allowed_types | A list of allowed instance types. PostgreSQL wildcards are supported. | ["%-micro", "%-small", "%-medium", "%-2", "%-4", "%-8", "%-16", "%-30", "%-32", "%-1g", "%-2g"] |
| compute_running_instance_age_max_days | The maximum number of days an instance can be running for. | 90 days |
| compute_snapshot_age_max_days | The maximum number of days a snapshot can be retained for. | 90 days |
