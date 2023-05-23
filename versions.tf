terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.66.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.3.0"
    }
  }
}
