resource "aws_ecs_service" "traefik" {
  name = "traefik"

  depends_on = [aws_lb_target_group.traefik]

  cluster         = aws_ecs_cluster.traefik.id
  task_definition = aws_ecs_task_definition.traefik.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.traefik_api.arn
    container_name   = "traefik"
    container_port   = 8080
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.traefik.arn
    container_name   = "traefik"
    container_port   = 80
  }

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.traefik_ecs.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "whoami" {
  name = "whoami"

  cluster         = aws_ecs_cluster.traefik.id
  task_definition = aws_ecs_task_definition.whoami.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.whoami.id]
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_log_group" "traefik" {
  name              = "traefik-logs"
  retention_in_days = 1
}
