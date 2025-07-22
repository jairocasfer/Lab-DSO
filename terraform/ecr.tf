resource "aws_ecr_repository" "webgoat" {
  name = "webgoat"
  image_tag_mutability = "MUTABLE"
}