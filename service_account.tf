resource "google_service_account" "cluster_user" {
  account_id   = "gke-account"
  display_name = "GKE Managed Account"
}

resource "google_project_iam_binding" "monitoring_viewer_user_iam" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  members = [
    "serviceAccount:${google_service_account.cluster_user.email}",
  ]
}

resource "google_project_iam_binding" "metrics_writer_user_iam" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  members = [
    "serviceAccount:${google_service_account.cluster_user.email}",
  ]
}

resource "google_project_iam_binding" "log_writer_user_iam" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  members = [
    "serviceAccount:${google_service_account.cluster_user.email}",
  ]
}

resource "google_project_iam_binding" "metatada_writer_user_iam" {
  project = var.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
  members = [
    "serviceAccount:${google_service_account.cluster_user.email}",
  ]
}

resource "google_service_account" "application_user" {
  account_id   = "gke-application"
  display_name = "GKE Application Account"
}

resource "google_service_account_iam_binding" "workloadIdentityUser_iam" {
  depends_on         = [kubernetes_service_account.redmine_user]
  service_account_id = google_service_account.application_user.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${kubernetes_namespace.redmine.metadata.0.name}/${kubernetes_service_account.redmine_user.metadata.0.name}]",
  ]
}

resource "google_project_iam_binding" "clous_sql_iam" {
  project = var.project_id
  role    = "roles/cloudsql.client"

  members = [
    "serviceAccount:${google_service_account.application_user.email}",
  ]
}
