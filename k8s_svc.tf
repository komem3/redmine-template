resource "kubernetes_service" "redmine_node_port" {
  metadata {
    name      = "redmine-svc"
    namespace = kubernetes_namespace.redmine.metadata.0.name
    annotations = {
      "cloud.google.com/backend-config" = "{\"ports\": {\"8080\": \"redmine-backendconfig\"}}"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.redmine.metadata.0.labels.app
    }
    port {
      name        = "http-port"
      port        = 8080
      target_port = 3000
      protocol    = "TCP"
    }
    type = "NodePort"
  }
}
