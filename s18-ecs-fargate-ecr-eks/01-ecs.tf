resource "aws_ecs_cluster" "demo" {
  name = "DemoCluster"

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.demo.arn
  }
}

resource "aws_ecs_service" "demo" {
  name                          = "nginxdemos-hello"
  cluster                       = aws_ecs_cluster.demo.id
  launch_type                   = "FARGATE"

  ###########################################################################
  desired_count                 = 3 # <-- Update with the number of instances
  ###########################################################################

  availability_zone_rebalancing = "ENABLED"
  wait_for_steady_state         = false
  task_definition               = "${aws_ecs_task_definition.demo.family}:${aws_ecs_task_definition.demo.revision}"
  enable_ecs_managed_tags       = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    container_name   = "nginxdemos-hello"
    container_port   = 80
    target_group_arn = aws_lb_target_group.ecs_lb_target_group.arn
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.demo.id]
    subnets          = data.aws_subnets.default.ids
  }
}

resource "aws_ecs_task_definition" "demo" {
  family = "nginxdemos-hello"

  container_definitions = jsonencode(
    [
      {
        name  = "nginxdemos-hello"
        image = "nginxdemos/hello"
        cpu   = 0
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
            name          = "80"
            appProtocol   = "http"
          }
        ]
        essential        = true
        environment      = []
        environmentFiles = []
        mountPoints      = []
        volumesFrom      = []
        ulimits          = []
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "/ecs/nginxdemos-hello"
            awslogs-create-group  = "true"
            awslogs-region        = var.region
            awslogs-stream-prefix = "ecs"
          },
          secretOptions = []
        },
        systemControls = []
      }
    ]
  )
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  enable_fault_injection   = false
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_lb" "ecs_lb" {
  name               = "DemoALBForECS"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.demo.id]
}

resource "aws_lb_target_group" "ecs_lb_target_group" {
  name = "tg-nginxdemos-hello"

  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.ecs_lb_target_group.arn
        weight = 1
      }
    }
  }
}

resource "aws_service_discovery_http_namespace" "demo" {
  name = "DemoCluster"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "demo" {
  name        = "nginxdemos-hello"
  description = "SC for NGINX"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.demo.id
  ip_protocol       = "-1"
  to_port           = -1
  from_port         = -1
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "http_in" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.demo.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}
# ipv6?

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

data "aws_iam_policy_document" "ecs_assume" {
  version = "2008-10-17"
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

output "load_balancer_dns" {
  value = aws_lb.ecs_lb.dns_name
}