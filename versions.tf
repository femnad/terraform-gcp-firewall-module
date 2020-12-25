terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.4"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 1.1"
    }
  }
}
