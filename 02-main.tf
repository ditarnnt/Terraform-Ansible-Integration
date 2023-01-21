terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.16.0"
    }
  }
}
provider "google" {
  credentials = file("projectsdn-f7e46ff7e80b.json")
  project     = local.project_id
  region      = "us-central1"
}