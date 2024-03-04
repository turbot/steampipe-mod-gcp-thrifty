mod "gcp_thrifty" {
  # Hub metadata
  title         = "GCP Thrifty"
  description   = "Are you a Thrifty GCP developer? This mod checks your GCP project(s) for unused and under-utilized resources using Powerpipe and Steampipe."
  color         = "#ea4335"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/gcp-thrifty.svg"
  categories    = ["gcp", "cost", "thrifty", "public cloud"]

  opengraph {
    title       = "Powerpipe mod for GCP Thrifty"
    description = "Are you a Thrifty GCP dev? This mod checks your GCP project(s) for unused and under-utilized resources using Powerpipe and Steampipe."
    image       = "/images/mods/turbot/gcp-thrifty-social-graphic.png"
  }
}
