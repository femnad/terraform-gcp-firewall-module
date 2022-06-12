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

  source_ranges = [format("%s/32", jsondecode(data.http.ipinfo.body).ip)]
}

resource "google_compute_firewall" "world-reachable" {
  name = "world-reachable"
  network = var.network

  dynamic "allow" {
    for_each = length(var.world_reachable) > 0 ? var.world_reachable : local.default_allow

    content {
      protocol = allow.value
      ports    = split(",", allow.key)
    }
  }

  source_ranges = ["0.0.0.0/0"]
}
