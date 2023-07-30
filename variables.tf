variable "self_reachable" {
  default = {}
}

variable "world_reachable" {
  type = object({
    remote_ips = optional(list(string))
    port_map   = map(string)
  })
  default = null
}

variable "network" {}

variable "rule_name" {
  default = "reachable"
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

variable "self_reachable_name" {
  type        = string
  default     = null
  description = "Name of firewall rules for self-reachability"
}

variable "world_reachable_name" {
  type        = string
  default     = null
  description = "Name of firewall rules for world-reachability"
}
