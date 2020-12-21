resource "kubernetes_namespace" "redmine" {
  metadata {
    name = "redmine-namespace"
  }
}
