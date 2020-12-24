resource "kubernetes_ingress" "redmine_ingress" {
  depends_on = [google_compute_global_address.redmine_address_ip, kubernetes_service.redmine_svc]
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
      service_name = kubernetes_service.redmine_svc.metadata.0.name
      service_port = kubernetes_service.redmine_svc.spec.0.port.0.port
    }
  }
}
