variable "ami" {
  type    = string
  default = "ami-0f924dc71d44d23e2"
}
variable "region" {
  type    = string
  default = "us-east-2"
}
variable "availability_zone" {
  type    = string
  default = "us-east-2a"
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.small"
}
variable "db_name" {
  type    = string
  default = "project_3_rds"
}
variable "db_username" {
  type      = string
  sensitive = true
}
variable "db_password" {
  type      = string
  sensitive = true
}