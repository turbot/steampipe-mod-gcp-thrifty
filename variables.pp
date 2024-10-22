// Benchmarks and controls for specific services should override the "service" tag
locals {
  gcp_thrifty_common_tags = {
    category = "Cost"
    plugin   = "gcp"
    service  = "GCP"
  }
}

variable "common_dimensions" {
  type        = list(string)
  description = "A list of common dimensions to add to each control."
  # Define which common dimensions should be added to each control.
  # - connection_name (_ctx ->> 'connection_name')
  # - location
  # - project
  default     = [ "location", "project" ]
}

variable "tag_dimensions" {
  type        = list(string)
  description = "A list of tags to add as dimensions to each control."
  # A list of tag names to include as dimensions for resources that support
  # tags (e.g. "owner", "environment"). Default to empty since tag names are
  # a personal choice
  default     = []
}

locals {

  common_dimensions_qualifier_sql = <<-EOQ
  %{~ if contains(var.common_dimensions, "connection_name") }, __QUALIFIER___ctx ->> 'connection_name'%{ endif ~}
  %{~ if contains(var.common_dimensions, "location") }, __QUALIFIER__location%{ endif ~}
  %{~ if contains(var.common_dimensions, "project") }, __QUALIFIER__project%{ endif ~}
  EOQ

  tag_dimensions_qualifier_sql = <<-EOQ
  %{~ for dim in var.tag_dimensions },  __QUALIFIER__tags ->> '${dim}' as "${replace(dim, "\"", "\"\"")}"%{ endfor ~}
  EOQ

}

locals {

  common_dimensions_sql = replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "")
  tag_dimensions_sql = replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "")
}