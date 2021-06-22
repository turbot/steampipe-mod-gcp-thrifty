locals {
  thrifty_common_tags = {
    plugin      = "gcp"
  }
  required_aws_tags = [
    "gcp:createdBy"
  ]
}

benchmark "thrifty_gcp" {
  title         = "GCP Thrifty <(ﾟ´(｡｡)`ﾟ)>"
  description   = "Find unused, under-utilized and over-priced resources in your GCP account."
  #documentation = file("./controls/docs/thrifty.md")
  children = [
    benchmark.compute,
  ]
  tags = local.thrifty_common_tags
 }
