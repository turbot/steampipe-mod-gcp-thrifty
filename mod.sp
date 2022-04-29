// Benchmarks and controls for specific services should override the "service" tag
locals {
  gcp_thrifty_common_tags = {
    category = "Cost"
    plugin   = "gcp"
    service  = "GCP"
  }
}

mod "gcp_thrifty" {
  # hub metadata
  title         = "GCP Thrifty"
  description   = "Are you a Thrifty GCP developer? This Steampipe mod checks your GCP project(s) to check for unused and under utilized resources."
  color         = "#ea4335"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/gcp-thrifty.svg"
  categories    = ["gcp", "cost", "thrifty", "public cloud"]

  opengraph {
    title       = "Thrifty mod for GCP"
    description = "Are you a Thrifty GCP dev? This Steampipe mod checks your GCP project(s) for unused and under-utilized resources."
    image       = "/images/mods/turbot/gcp-thrifty-social-graphic.png"
  }
}
