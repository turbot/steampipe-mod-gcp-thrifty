## v0.11 [2023-02-03]

_What's new?_

- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/gcp_thrifty/variables)) ([#41](https://github.com/turbot/steampipe-mod-gcp-thrifty/pull/41))
- Added `connection_name` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/gcp_thrifty/variables)) ([#41](https://github.com/turbot/steampipe-mod-gcp-thrifty/pull/41))

## v0.10 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#36](https://github.com/turbot/steampipe-mod-gcp-thrifty/pull/36))

## v0.9 [2022-05-02]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#32](https://github.com/turbot/steampipe-mod-gcp-thrifty/pull/32))

## v0.8 [2022-04-06]

_Bug fixes_

- Fixed the inline query of `compute_snapshot_max_age` control to correctly review the age of snapshots ([#28](https://github.com/turbot/steampipe-mod-gcp-thrifty/pull/28))

## v0.7 [2022-03-29]

_What's new?_

- Added default values to all variables (set to the same values in `steampipe.spvars.example`)
- Added `*.spvars` and `*.auto.spvars` files to `.gitignore`
- Renamed `steampipe.spvars` to `steampipe.spvars.example`, so the variable default values will be used initially. To use this example file instead, copy `steampipe.spvars.example` as a new file `steampipe.spvars`, and then modify the variable values in it. For more information on how to set variable values, please see [Input Variable Configuration](https://hub.steampipe.io/mods/turbot/gcp_thrifty#configuration).

## v0.6 [2021-11-03]

_Bug fixes_

- Fixed the broken link for the console output image in the `docs/index.md` file

## v0.5 [2021-11-03]

_Enhancements_

- `docs/index.md` file now includes the console output image

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
