resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ECRUserAccessPolicy"
  description = "IAM policy for ECR access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
            "eks:DescribeCluster"
        ],
        "Resource": "arn:aws:eks:eu-west-2:*:cluster/exa-assessment-cluster"
      },
      {
        "Effect": "Allow",
        "Action": [
            "eks:ListClusters"
        ],
        "Resource": "*"
      },
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
      },
      {
          "Effect": "Allow",
          "Action": [
              "eks:*"
          ],
          "Resource": "arn:aws:eks:eu-west-2:*:cluster/exa-assessment-cluster"
      },
      {
          "Effect": "Allow",
          "Action": [
              "ec2:DescribeInstances",
              "ec2:DescribeRouteTables",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeSubnets",
              "ec2:DescribeVolumes",
              "ec2:DescribeVpcs"
          ],
          "Resource": "*",
          "Condition": {
              "StringEquals": {
                  "aws:RequestedRegion": "eu-west-2"
              }
          }
      },
      {
          "Effect": "Allow",
          "Action": [
              "iam:GetRole",
              "iam:ListAttachedRolePolicies",
              "iam:ListRoles",
              "iam:ListRolePolicies",
              "iam:PassRole"
          ],
          "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ecr_user_policy_attach" {
  user       = aws_iam_user.ecr_user.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}