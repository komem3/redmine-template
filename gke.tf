resource "google_container_cluster" "redmine" {
  name     = "redmine-cluster"
  location = local.project.region

  remove_default_node_pool = true
  initial_node_count       = 1
  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  database_encryption {
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.redmine_key.id
  }

  enable_shielded_nodes = true

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "redmine_nodes" {
  name       = "redmine-node-pool"
  location   = local.project.region
  cluster    = google_container_cluster.redmine.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    image_type   = "cos_containerd"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = google_service_account.cluster_user.email

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

  }
}
