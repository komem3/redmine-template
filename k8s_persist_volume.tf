resource "kubernetes_persistent_volume" "redmine_pv" {
  metadata {
    name = "redmine-files-pv"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    capacity = {
      storage = "100Gi"
    }
    storage_class_name = "standard"
    persistent_volume_source {
      nfs {
        path   = "/${google_filestore_instance.redmine_file_store.file_shares.0.name}"
        server = google_filestore_instance.redmine_file_store.networks.0.ip_addresses.0
      }
    }
  }
}
