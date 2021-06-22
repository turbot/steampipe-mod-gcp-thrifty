mod "gcp_thrifty" {
  # hub metadata
  title         = "GCP Thrifty"
  description   = "Are you a Thrifty GCP developer? This Steampipe mod checks your GCP projects(s) to check for unused and under utilized resources."
  color         = "#FF9900"
  #documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/aws-thrifty.svg"
  categories    = ["gcp", "cost", "thrifty", "public cloud"]

  opengraph {
    title       = "Thrifty mod for GCP"
    description = "Are you a Thrifty GCP dev? This Steampipe mod checks your GCP project(s) for unused and under-utilized resources."
    #image       = "/images/mods/turbot/aws-thrifty-social-graphic.png"
  }
}
