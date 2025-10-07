resource "aws_ecr_repository" "wiz_app" {
  name = "wiz-app"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "wiz-app-ecr"
    Environment = var.env
  }
}
