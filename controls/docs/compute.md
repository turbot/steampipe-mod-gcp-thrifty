## Thrifty Compute Benchmark

Thrifty developers eliminate their unused and under-utilized compute instances.
This benchmark focuses on finding resources that have not been restarted
recently, are using very large instance sizes, have old snapshots, and have
unused disks and IP addresses.

### Default Thresholds

- [Disks that are large (> 100 GB)](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/controls/compute.sp#L87)
- [Instance types that are too big (> 32 vCPU)](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/controls/compute.sp#L137)
- [Long running instance threshold (90 Days)](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/controls/compute.sp#L160)
- [Snapshot age threshold (90 Days)](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/controls/compute.sp#L185)
