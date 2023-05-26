data "http" "ipinfo" {
  url = "https://ipinfo.io/json"
}

locals {
  default_allow = {
    "" = "icmp"
  }
  public_ip = jsondecode(data.http.ipinfo.response_body).ip
  ip_prefix = format("%s/%s", local.public_ip, var.ip_mask)
  ips = {
    for host in range(var.ip_num) :
    "range" => {
      ip = cidrhost(local.ip_prefix, host)
    }...
  }
  prefix = length(var.prefix) > 0 ? var.prefix : "${random_pet.prefix.id}"
}

resource "random_pet" "prefix" {
}

resource "google_compute_firewall" "self-reachable" {
  name    = "${local.prefix}-self-reachable"
  network = var.network

  dynamic "allow" {
    for_each = length(var.self_reachable) > 0 ? var.self_reachable : local.default_allow

    content {
      protocol = allow.value
      ports    = allow.value == "icmp" ? null : split(",", allow.key)
    }
  }

  source_ranges = [for ip in local.ips.range : ip.ip]
}

resource "google_compute_firewall" "world-reachable" {
  name    = "${local.prefix}-world-reachable"
  network = var.network
  count   = var.world_reachable != null ? 1 : 0

  dynamic "allow" {
    for_each = var.world_reachable.port_map

    content {
      protocol = allow.value
      ports    = allow.value == "icmp" ? null : split(",", allow.key)
    }
  }

  source_ranges = var.world_reachable.remote_ips == null ? ["0.0.0.0/0"] : var.world_reachable.remote_ips
}
