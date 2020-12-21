variable "project_id" {
  type      = string
  sensitive = true
}

variable "docker_tag" {
  type        = string
  description = "tag of redmine docker image"
}

variable "redmine_admin" {
  type        = string
  default     = "admin"
  description = "redmine admin name"
  sensitive   = true
}

variable "redmine_pass" {
  type        = string
  description = "redmine admin password"
  sensitive   = true
}

variable "db_pass" {
  type        = string
  description = "password of user for redmine db"
  sensitive   = true
}

variable "smtp_host" {
  type        = string
  description = "host of smtp"
  sensitive   = true
}

variable "smtp_port" {
  type        = string
  description = "port of smtp"
  sensitive   = true
}

variable "smtp_user" {
  type        = string
  description = "user of smtp"
  sensitive   = true
}

variable "smtp_pass" {
  type        = string
  description = "password of smtp"
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
