resource "kubernetes_ingress" "redmine_ingress" {
  depends_on = [google_compute_global_address.redmine_address_ip]
  metadata {
    name      = "redmine-ingress"
    namespace = kubernetes_namespace.redmine.metadata.0.name
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.redmine_address_ip.name
      "networking.gke.io/managed-certificates"      = "redmine-certificate"
      "kubernetes.io/ingress.allow-http"            = false
    }
  }

  spec {
    backend {
      service_name = kubernetes_service.redmine_node_port.metadata.0.name
      service_port = 8080
    }
  }
}
