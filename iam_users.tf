# Creates the new IAM user to be used for GitHub actions
resource "aws_iam_user" "ecr_user" {
  name = "ecr-user"
  path = "/system/"
}

