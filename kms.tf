resource "google_kms_key_ring" "redmine_keyring" {
  name     = "redmine-keyring"
  location = local.project.region
}

resource "google_kms_key_ring_iam_binding" "redmine_keyring" {
  key_ring_id = google_kms_key_ring.redmine_keyring.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}

resource "google_kms_crypto_key" "redmine_key" {
  name            = "redmine-crypto-key"
  key_ring        = google_kms_key_ring.redmine_keyring.id
  rotation_period = "604800s"
  purpose         = "ENCRYPT_DECRYPT"

  lifecycle {
    prevent_destroy = true
  }
}
