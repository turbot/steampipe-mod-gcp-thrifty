locals {
  thrifty_common_tags = {
    plugin      = "gcp"
  }
  required_gcp_tags = [
    "gcp:createdBy"
  ]
}

# benchmark "thrifty_gcp" {
#   title         = "GCP Thrifty <(ﾟ´(｡｡)`ﾟ)>"
#   description   = "Find unused, under-utilized and over-priced resources in your GCP project."
#   documentation = file("./controls/docs/thrifty.md")
#   children = [
#     benchmark.bigquery,
#     benchmark.compute,
#     benchmark.storage,
#   ]
#   tags = local.thrifty_common_tags
# }