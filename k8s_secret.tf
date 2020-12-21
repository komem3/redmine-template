resource "kubernetes_secret" "redmine_secret" {
  metadata {
    name      = "redmine-secret"
    namespace = kubernetes_namespace.redmine.metadata.0.name
  }

  data = {
    redmine_admin = var.redmine_admin
    redmine_pass  = var.redmine_pass
    db_pass       = var.db_pass
    smtp_host     = var.smtp_host
    smtp_port     = var.smtp_port
    smtp_user     = var.smtp_user
    smtp_pass     = var.smtp_pass
  }

  type = "Opaque"
}
