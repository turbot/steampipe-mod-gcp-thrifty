## v0.5 [2021-11-03]

_Enhancements_

- docs/index.md file now includes the console output image

_Bug fixes_

- Fixed the `sql_db_instance_avg_cpu_utilization_high` variable to use `50%` instead of `25%` ([18](https://github.com/turbot/steampipe-mod-gcp-thrifty/pull/18))

## v0.4 [2021-09-27]

_What's new?_

- Added: Input variables have been added to most controls to allow different thresholds to be passed in. To get started, please see [GCP Thrifty Configuration](https://hub.steampipe.io/mods/turbot/gcp_thrifty#configuration) and for a list of variables and their default values, please see [steampipe.spvars](https://github.com/turbot/steampipe-mod-gcp-thrifty/blob/main/steampipe.spvars).

## v0.3 [2021-09-23]

_Bug fixes_

- Fixed broken links to the Mod developer guide and LICENSE in README.md

## v0.2 [2021-07-23]

_What's new?_

- New controls added:
  - compute_disk_low_usage
  - compute_instance_low_utilization
  - logging_bucket_higher_retention_period
  - sql_db_instance_low_connection_count
  - sql_db_instance_low_utilization

_Bug fixes_

- Fixed: Brand color now matches GCP plugin brand color

## v0.1 [2021-06-24]

_What's new?_

- Added initial BigQuery, Compute, and Storage benchmarks
