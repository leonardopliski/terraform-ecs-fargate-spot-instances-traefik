[
  {
    "name": "whoami",
    "image": "containous/whoami:v1.5.0",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "dockerLabels": {
      "traefik.http.routers.whoami.rule": "Host(`${alb_endpoint}`)",
      "traefik.enable": "true"
    }
  }
]
