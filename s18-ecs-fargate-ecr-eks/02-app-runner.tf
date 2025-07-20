resource "aws_apprunner_service" "demo" {
  service_name = "DemoHTTP"


  source_configuration {
    image_repository {
      image_identifier      = "public.ecr.aws/docker/library/httpd:latest"
      image_repository_type = "ECR_PUBLIC"

      image_configuration {
        port = "80"
      }
    }
    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu               = 1024
    memory            = 2048
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.demo_asc.arn

  health_check_configuration {
    timeout = 5
    interval = 10
    unhealthy_threshold = 5
    healthy_threshold = 1

    protocol = "HTTP"
    path = "/"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "demo_asc" {
  auto_scaling_configuration_name = "demo"

  max_concurrency = 100
  min_size = 1
  max_size = 25
}

output "app_runner_service_url" {
  value = aws_apprunner_service.demo.service_url
}