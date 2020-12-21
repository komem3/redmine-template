resource "google_artifact_registry_repository" "redmine_repo" {
  provider = google-beta

  location      = local.project.region
  repository_id = "redmine-repo"
  description   = "registry for redmine docker image"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_member" "redmine_docker_iam" {
  provider = google-beta

  location   = google_artifact_registry_repository.redmine_repo.location
  repository = google_artifact_registry_repository.redmine_repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.cluster_user.email}"
}
