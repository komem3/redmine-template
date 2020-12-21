terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.8.0"
    }
  }
  # backend "gcs" {
  #   bucket = "-tf-state"
  # }
}

provider "kubernetes" {
  load_config_file = false
  host             = "https://${google_container_cluster.redmine.endpoint}"
  token            = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.redmine.master_auth[0].cluster_ca_certificate,
  )
}

provider "docker" {}

provider "google" {
  project = var.project_id
  region  = local.project.region
  zone    = local.project.zone
}

provider "google-beta" {
  project = var.project_id
  region  = local.project.region
  zone    = local.project.zone
}


data "google_client_config" "provider" {}
