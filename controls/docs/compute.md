## Thrifty Compute Benchmark

Thrifty developers eliminate their unused and under-utilized compute instances. This benchmark focuses on finding resources that have not been restarted recently, have unused disks, have unused ip addresses, have old snapshots, using low performance disks and are using very large instance sizes.

### Default Thresholds
- [Instance types that are too big (> 32 vCPU)]
- [Compute disk that are large (> 100 GB)]
- [Long running instance threshold (90 Days)]
- [Compute snapshot age threshold (90 Days)]