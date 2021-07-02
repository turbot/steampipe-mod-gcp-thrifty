---
repository: "https://github.com/turbot/steampipe-mod-gcp-thrifty"
---

# GCP Thrifty Mod

Be Thrifty on GCP! This mod checks for unused resources and opportunities to optimize your spend on GCP.

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
git clone git@github.com:turbot/steampipe-mod-gcp-thrifty
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

No extra configuration is required.

## Get involved

* Contribute: [Help wanted issues](https://github.com/turbot/steampipe-mod-gcp-thrifty/labels/help%20wanted)
* Community: [Slack channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
