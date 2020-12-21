resource "kubernetes_deployment" "redmine" {
  depends_on = [kubernetes_persistent_volume_claim.redmine_pv_claim, google_artifact_registry_repository_iam_member.redmine_docker_iam]
  metadata {
    name      = "redmine-deployment"
    namespace = kubernetes_namespace.redmine.metadata.0.name
    labels = {
      app = "redmine"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redmine"
      }
    }

    template {
      metadata {
        labels = {
          app = "redmine"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.redmine_user.metadata.0.name
        container {
          image             = "asia-northeast1-docker.pkg.dev/${var.project_id}/redmine-repo/redmine:${var.docker_tag}"
          name              = "redmine"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "REDMINE_DB_POSTGRES"
            value = "127.0.0.1"
          }

          env {
            name  = "REDMINE_DB_NAME"
            value = google_sql_database.redmine_db.name
          }

          env {
            name  = "REDMINE_DB_USERNAME"
            value = google_sql_user.redmine_user.name
          }

          env {
            name  = "REDMINE_DB_PORT_NUMBER"
            value = 5432
          }

          env {
            name  = "REDMINE_LANGUAGE"
            value = "ja"
          }

          env {
            name = "REDMINE_USERNAME"
            value_from {
              secret_key_ref {
                key  = "redmine_admin"
                name = kubernetes_secret.redmine_secret.metadata.0.name
              }
            }
          }

          env {
            name = "REDMINE_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "redmine_pass"
                name = kubernetes_secret.redmine_secret.metadata.0.name
              }
            }
          }

          env {
            name = "REDMINE_DB_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "db_pass"
                name = kubernetes_secret.redmine_secret.metadata.0.name
              }
            }
          }

          env {
            name = "SMTP_HOST"
            value_from {
              secret_key_ref {
                key  = "smtp_host"
                name = kubernetes_secret.redmine_secret.metadata.0.name
              }
            }
          }

          env {
            name = "SMTP_PORT"
            value_from {
              secret_key_ref {
                key  = "smtp_port"
                name = kubernetes_secret.redmine_secret.metadata.0.name
              }
            }
          }

          env {
            name = "SMTP_USER"
            value_from {
              secret_key_ref {
                key  = "smtp_user"
                name = kubernetes_secret.redmine_secret.metadata.0.name
              }
            }
          }

          env {
            name = "SMTP_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "smtp_pass"
                name = kubernetes_secret.redmine_secret.metadata.0.name
              }
            }
          }

          resources {
            limits {
              cpu    = "500m"
              memory = "256Mi"
            }
            requests {
              cpu    = "250m"
              memory = "128Mi"
            }
          }

          port {
            name           = "redmine-port"
            container_port = 3000
          }

          volume_mount {
            mount_path = "/usr/src/redmine/files"
            name       = "files-pvc"
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "redmine-port"
            }
            initial_delay_seconds = 90
            period_seconds        = 20
            success_threshold     = 1
            failure_threshold     = 3
            timeout_seconds       = 10
          }
          readiness_probe {
            http_get {
              path = "/"
              port = "redmine-port"
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
            timeout_seconds       = 5
          }
        }

        container {
          name  = "cloud-sql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.17"
          command = [
            "/cloud_sql_proxy",
            "-instances=${google_sql_database_instance.redmine.connection_name}=tcp:5432",
          ]
        }

        volume {
          name = "files-pvc"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.redmine_pv_claim.metadata.0.name
            read_only  = false
          }
        }

      }
    }
  }
}
