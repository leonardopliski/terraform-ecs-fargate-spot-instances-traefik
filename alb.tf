resource "aws_lb" "traefik" {
  name               = join("-", [var.namespace, var.stage, var.name, "traefik"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.traefik.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_target_group" "traefik_api" {
  name = join("-", [var.namespace, var.stage, var.name, "traefik-api"])

  depends_on = [aws_lb.traefik]

  target_type = "ip"
  port        = 8080
  protocol    = "HTTP"

  vpc_id = module.vpc.vpc_id

  health_check {
    path    = "/"
    matcher = "200-202,300-302"
  }
}

resource "aws_lb_target_group" "traefik" {
  name = join("-", [var.namespace, var.stage, var.name, "traefik"])

  depends_on  = [aws_lb.traefik]
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"

  vpc_id = module.vpc.vpc_id

  health_check {
    path    = "/"
    matcher = "200-202,404"
  }
}

resource "aws_lb_listener" "front" {
  load_balancer_arn = aws_lb.traefik.arn
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.traefik.arn
  }
}

resource "aws_lb_listener" "front_api" {
  load_balancer_arn = aws_lb.traefik.arn
  port              = 8080

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.traefik_api.arn
  }
}
