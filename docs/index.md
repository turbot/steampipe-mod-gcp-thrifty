---
repository: "https://github.com/turbot/steampipe-mod-gcp-thrifty"
---

# GCP Thrifty Mod

Be Thrifty on GCP! This mod checks for unused resources and opportunities to optimize your spend on GCP.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-gcp-thrifty/main/docs/gcp-thrifty-console-graphic.png)

## References

[GCP](https://cloud.google.com) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis. 

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/gcp_thrifty/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/gcp_thrifty/queries)**

## Get started

Install the GCP plugin with [Steampipe](https://steampipe.io):
```shell
steampipe plugin install gcp
```

Clone:
```sh
git clone https://github.com/turbot/steampipe-mod-gcp-thrifty.git
cd steampipe-mod-gcp-thrifty
```

Run all benchmarks:
```shell
steampipe check all
```

Run a specific control:
```shell
steampipe check control.compute_disk_unattached
```

### Credentials

This mod uses the credentials configured in the [Steampipe GCP plugin](https://hub.steampipe.io/plugins/turbot/gcp).

### Configuration

Several benchmarks have [input variables](https://steampipe.io/docs/using-steampipe/mod-variables) that can be configured to better match your environment and requirements. Each variable has a default defined in its source file, e.g., `controls/sql.sp`, but these can be overwritten in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.bigquery --var=bigquery_table_stale_data_max_days=90
  ```

- Set an environment variable:

  ```shell
  SP_VAR_bigquery_table_stale_data_max_days=90 steampipe check control.bigquery_table_stale_data
  ```

  - Note: When using environment variables, if the variable is defined in `steampipe.spvars` or passed in through the command line, either of those will take precedence over the environment variable value. For more information on variable definition precedence, please see the link below.

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://steampipe.io/docs/using-steampipe/mod-variables#passing-input-variables).

## Get involved

* Contribute: [Help wanted issues](https://github.com/turbot/steampipe-mod-gcp-thrifty/labels/help%20wanted)
* Community: [Slack channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
