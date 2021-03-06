provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
  credentials = var.service_account_file
}

data "http" "ipinfo" {
  url = "https://ipinfo.io/json"
}

resource "google_compute_firewall" "self-reachable" {
  name = "self-reachable"
  network = var.network

  dynamic "allow" {
    for_each = var.self_reachable

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
    for_each = var.world_reachable

    content {
      protocol = allow.value
      ports    = split(",", allow.key)
    }
  }

  source_ranges = ["0.0.0.0/0"]
}
