resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database" "redmine_db" {
  name     = "redmine_db"
  instance = google_sql_database_instance.redmine.name
}

resource "google_sql_database" "redmine_user_db" {
  name     = google_sql_user.redmine_user.name
  instance = google_sql_database_instance.redmine.name
}

resource "google_sql_database_instance" "redmine" {
  name                = "redmine-instance-${random_id.db_name_suffix.hex}"
  database_version    = "POSTGRES_13"
  region              = local.project.region
  deletion_protection = var.production_flag
  settings {
    tier              = "db-f1-micro"
    availability_type = var.production_flag ? "REGIONAL" : "ZONAL"
    backup_configuration {
      enabled                        = var.production_flag
      point_in_time_recovery_enabled = var.production_flag
    }
  }
}

resource "google_sql_user" "redmine_user" {
  name            = "redmine_user"
  instance        = google_sql_database_instance.redmine.name
  password        = var.db_pass
  deletion_policy = "ABANDON"
}
