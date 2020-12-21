resource "kubernetes_persistent_volume_claim" "redmine_pv_claim" {
  depends_on = [kubernetes_persistent_volume.redmine_pv]
  metadata {
    name      = "redmine-files-pv-claim"
    namespace = kubernetes_namespace.redmine.metadata.0.name
    labels = {
      storage = "redmine"
    }
  }
  spec {
    storage_class_name = "standard"
    access_modes       = ["ReadWriteMany"]
    volume_name        = kubernetes_persistent_volume.redmine_pv.metadata.0.name
    resources {
      requests = {
        storage = "100Gi"
      }
    }
  }
}
