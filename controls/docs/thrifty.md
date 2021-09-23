## Overview

The Thrifty GCP Benchmark provides prescriptive checks for discovery of unused, unmanaged, under-utilized and outdated GCP resources. Specific GCP services in scope include:

* GCP BigQuery
* GCP Compute
* GCP Logging
* GCP SQL
* GCP Storage

## Configuration

Several benchmarks have [input variables](https://steampipe.io/docs/using-steampipe/mod-variables) that can be configured to better match your environment and requirements. Each variable has a default defined in `steampipe.spvars`, but these can be overwritten in several ways:

* Modify the `steampipe.spvars` file
* Remove or comment out the value in `steampipe.spvars`, after which Steampipe will prompt you for a value when running a query or check
* Pass in a value on the command line:

  ```shell
  steampipe check benchmark.bigquery --var=bigquery_table_stale_data_max_days=90
  ```

* Set an environment variable:

  ```shell
  SP_VAR_bigquery_table_stale_data_max_days=90 steampipe check control.bigquery_table_stale_data
  ```

  * Note: When using environment variables, if the variable is defined in `steampipe.spvars` or passed in through the command line, either of those will take precedence over the environment variable value. For more information on variable definition precedence, please see the link below.

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://steampipe.io/docs/using-steampipe/mod-variables#passing-input-variables).
