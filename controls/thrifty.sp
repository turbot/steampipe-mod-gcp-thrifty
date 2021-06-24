locals {
  thrifty_common_tags = {
    plugin      = "gcp"
  }
  required_gcp_tags = [
    "gcp:createdBy"
  ]
}