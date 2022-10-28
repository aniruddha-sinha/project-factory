terraform {
  backend "gcs" {
    bucket = "odin-admin-state-bkt"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.41.0"
    }
  }
}

provider "google" {
  # Configuration options
}