data "template_file" "traefik_task_definition_template" {
  template = file("${path.module}/templates/traefik.task_definition.json.tpl")
  vars = {
    region                    = var.region
    aws_access_key_id         = var.aws_access_key_id
    aws_secret_access_key_arn = var.aws_secret_access_key_arn
    loggroup                  = aws_cloudwatch_log_group.traefik.name
    ecs_cluster_name          = aws_ecs_cluster.traefik.name
  }
}

data "template_file" "whoami_task_definition_template" {
  template = file("${path.module}/templates/whoami.task_definition.json.tpl")
  vars = {
    alb_endpoint = aws_lb.traefik.dns_name
  }
}

resource "aws_ecs_task_definition" "traefik" {
  family                   = "traefik"
  container_definitions    = data.template_file.traefik_task_definition_template.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_role.arn
  task_role_arn            = aws_iam_role.traefik.arn
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_task_definition" "whoami" {
  depends_on               = [aws_ecs_task_definition.traefik]
  family                   = "whoami"
  container_definitions    = data.template_file.whoami_task_definition_template.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}
