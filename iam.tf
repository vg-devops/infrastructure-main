resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ECRUserAccessPolicy"
  description = "IAM policy for ECR access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "arn:aws:ecr:*:*:repository/*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:CreateRepository"
        ]
        Resource = "arn:aws:ecr:*:*:repository/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ecr_user_policy_attach" {
  user       = aws_iam_user.ecr_user.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}