# GCP Thrifty Mod

Be Thrifty on GCP! This mod checks for unused resources and opportunities to optimize your spend on GCP.

<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-gcp-thrifty/main/docs/gcp_thrifty_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-gcp-thrifty/main/docs/gcp_thrifty_compute_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-gcp-thrifty/main/docs/gcp_thrifty_console_graphic.png" width="50%" type="thumbnail"/>

## Documentation

- **[Benchmarks and controls →](https://hub.powerpipe.io/mods/turbot/gcp_thrifty/controls)**

## Getting Started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [GCP plugin](https://hub.steampipe.io/plugins/turbot/gcp) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install gcp
```

Steampipe will automatically use your default GCP credentials. Optionally, you can [setup multiple projects](https://hub.steampipe.io/plugins/turbot/gcp#multi-project-connections).

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-gcp-thrifty
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **http://localhost:9033**.

### Running Checks in Your Terminal

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `powerpipe benchmark` command:

List available benchmarks:

```sh
powerpipe benchmark list
```

Run a benchmark:

```sh
powerpipe benchmark run gcp_thrifty.benchmark.compute
```

Different output formats are also available, for more information please see
[Output Formats](https://powerpipe.io/docs/reference/cli/benchmark#output-formats).

### Configure Variables

Several benchmarks have [input variables](https://powerpipe.io/docs/build/mod-variables#input-variabless) that can be configured to better match your environment and requirements. Each variable has a default defined in its source file, e.g., `controls/sql.sp`, but these can be overwritten in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp steampipe.ppvars.example steampipe.ppvars
vi steampipe.ppvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run gcp_thrifty.benchmark.bigquery --var=bigquery_table_stale_data_max_days=90
```

Or through environment variables:

```sh
export PP_VAR_bigquery_table_stale_data_max_days=90
powerpipe benchmark run gcp_thrifty.benchmark.bigquery
```

These are only some of the ways you can set variables. For a full list, please see [Passing Input Variables](https://powerpipe.io/docs/build/mod-variables#passing-input-variables).

### Common and Tag Dimensions

The benchmark queries use common properties (like `connection_name`, `location` and `project`) and tags that are defined in the form of a default list of strings in the `variables.sp` file. These properties can be overwritten in several ways:

It's easiest to setup your vars file, starting with the sample:

```sh
cp steampipe.ppvars.example steampipe.ppvars
vi steampipe.ppvars
```

Alternatively you can pass variables on the command line:

```sh
powerpipe benchmark run gcp_thrifty.benchmark.compute --var 'tag_dimensions=["environment", "owner"]'
```

Or through environment variables:

```sh
export PP_VAR_common_dimensions='["connection_name", "location", "project"]'
export PP_VAR_tag_dimensions='["environment", "owner"]'
powerpipe benchmark run gcp_thrifty.benchmark.compute
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [GCP Thrifty Mod](https://github.com/turbot/steampipe-mod-gcp-thrifty/labels/help%20wanted)
