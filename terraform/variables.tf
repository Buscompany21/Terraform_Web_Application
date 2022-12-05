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
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}
variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}
variable "health_check_path" {
  default = "/"
}
variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}
variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}
variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "latest"
}