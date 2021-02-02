resource "aws_ecs_cluster" "traefik" {
  name               = join("-", [var.namespace, var.stage, var.name])
  capacity_providers = ["FARGATE_SPOT"]
}
