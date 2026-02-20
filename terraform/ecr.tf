resource "aws_ecr_repository" "watchman_repo" {
  name = "watchman-repo"

  // for better versioning
  image_tag_mutability = "IMMUTABLE"

  // to look for CVEs
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Watchman Image Repository"
  }
}

// lifecycle as to not clog up the repo, probably won't need it, only did for learning purposes

resource "aws_ecr_lifecycle_policy" "watchman_repo_lifecycle" {
  repository = aws_ecr_repository.watchman_repo.name

  policy = data.aws_ecr_lifecycle_policy_document.old_images_remover

}

// expire old images if they exceed 5

data "aws_ecr_lifecycle_policy_document" "old_images_remover" {
  rule {
    priority    = 1
    description = "expiring old images"

    selection {
      // can do any
      tag_status      = "tagged"
      tag_prefix_list = ["watchman"]
      count_type      = "imageCountMoreThan"
      count_number    = 5
    }

    action {
      type = "expire"
    }
  }
}
