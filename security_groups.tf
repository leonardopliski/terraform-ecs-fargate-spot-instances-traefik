resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "traefik" {
  name        = join("-", [var.namespace, var.stage, var.name, "traefik-front"])
  vpc_id      = module.vpc.vpc_id
  description = "Allow SSH, HTTP and HTTPS traffic from ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "traefik_ecs" {
  name = join("-", [var.namespace, var.stage, var.name, "traefik-ecs"])

  vpc_id      = module.vpc.vpc_id
  description = "Allow SSH, HTTP and HTTPS traffic from ALB"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "whoami" {
  name = join("-", [var.namespace, var.stage, var.name, "whoami"])

  vpc_id      = module.vpc.vpc_id
  description = "Allow traffic from traefik security group"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik_ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
