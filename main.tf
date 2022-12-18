provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = var.service_account_file
}

data "http" "ipinfo" {
  url = "https://ipinfo.io/json"
}

locals {
  default_allow = {
    "" = "icmp"
  }
  public_ip = jsondecode(data.http.ipinfo.body).ip
  prefix = format("%s/%s", local.public_ip, var.ip_mask)
  ips = {
    for host in range(var.ip_num) :
    "range" => {
      ip = cidrhost(local.prefix, host)
    }...
  }
}

resource "google_compute_firewall" "self-reachable" {
  name = "self-reachable"
  network = var.network

  dynamic "allow" {
    for_each = length(var.self_reachable) > 0 ? var.self_reachable : local.default_allow

    content {
      protocol = allow.value
      ports    = split(",", allow.key)
    }
  }

  source_ranges = [for ip in local.ips.range: ip.ip]
}

resource "google_compute_firewall" "world-reachable" {
  name = "world-reachable"
  network = var.network

  dynamic "allow" {
    for_each = length(var.world_reachable) > 0 ? var.world_reachable : local.default_allow

    content {
      protocol = allow.value
      ports    = allow.value == "icmp" ? null : split(",", allow.key)
    }
  }

  source_ranges = length(var.world_reachable) > 0 ? ["0.0.0.0/0"] : ["127.0.0.1/32"]
}
