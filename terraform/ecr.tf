resource "aws_ecr_repository" "group-project-3-ecr_repo" {
  name = "group-project-3-ecr_repo"

  image_scanning_configuration {
    scan_on_push = true
  }
}