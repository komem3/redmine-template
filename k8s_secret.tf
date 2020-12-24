resource "kubernetes_secret" "redmine_secret" {
  metadata {
    name      = "redmine-secret"
    namespace = kubernetes_namespace.redmine.metadata.0.name
  }

  data = {
    db_pass    = var.db_pass
    secret_key = var.secret_key
  }

  type = "Opaque"
}
