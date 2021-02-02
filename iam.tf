data "aws_iam_policy_document" "traefik" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "traefik" {
  name               = "traefik"
  assume_role_policy = data.aws_iam_policy_document.traefik.json
}

data "aws_iam_policy_document" "traefik_policy" {
  statement {
    sid = "TraefikECSReadAccess"

    effect = "Allow"

    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances"
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "traefik_data_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]

    resources = [
      var.aws_secret_access_key_arn
    ]
  }
}

resource "aws_iam_role_policy" "traefik_policy" {
  name = "traefik_policy"
  role = aws_iam_role.traefik.id

  policy = data.aws_iam_policy_document.traefik_policy.json
}


resource "aws_iam_role_policy" "traefik_data_policy" {
  name   = "traefik_data_policy"
  role   = aws_iam_role.traefik.id
  policy = data.aws_iam_policy_document.traefik_data_policy.json
}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_policy_secrets" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ecs_role.name
}
