resource "google_filestore_instance" "redmine_file_store" {
  description = "used for share files of redmine"
  name        = "redmine-file-server"
  zone        = local.project.zone
  tier        = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "redmine_shares"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}
