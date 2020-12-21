resource "kubernetes_service_account" "redmine_user" {
  metadata {
    name      = "redminer-user"
    namespace = kubernetes_namespace.redmine.metadata.0.name
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.application_user.email
    }
  }
}
