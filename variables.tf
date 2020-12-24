variable "project_id" {
  type      = string
  sensitive = true
}

variable "docker_tag" {
  type        = string
  description = "tag of redmine docker image"
}

variable "db_pass" {
  type        = string
  description = "password of user for redmine db"
  sensitive   = true
}

variable "secret_key" {
  type        = string
  description = "used by Rails to encode cookies storing session data"
  sensitive   = true
}

variable "production_flag" {
  type        = bool
  description = "flag of production"
  default     = true
}

locals {
  project = {
    region = "asia-northeast1"
    zone   = "asia-northeast1-a"
  }
  storage_region = "asia"
}

data "google_project" "project" {}
