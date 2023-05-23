variable "project" {}

variable "self_reachable" {
  default = {}
}

variable "world_reachable" {
  type = object({
    remote_ips = optional(list(string))
    port_map = map(string)
  })
  default = null
}

variable "network" {}

variable "region" {
  default = "europe-west-1"
}

variable "rule_name" {
  default = "reachable"
}

variable "service_account_file" {
  default = ""
}

variable "zone" {
  default = "europe-west1-c"
}

variable "ip_mask" {
  default = 32
}

variable "ip_num" {
  default = 1
}

variable "prefix" {
  default = ""
}
