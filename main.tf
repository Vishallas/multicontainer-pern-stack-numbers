provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "multi" {
  name = "multicontainer-cluster-terraform"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "multi" {
  family = "multicontainer-task-def-terraform"

  container_definitions = jsonencode([
    {
      name         = "client"
      image        = "flickerflak/multicontainer-r2np-client"
      cpu          = 0
      portMappings = []
      essential    = true
      environment = [
        {
          name  = "CHOKIDAR_USEPOLLING"
          value = "true"
        }
      ]
      mountPoints = []
      volumesFrom = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/multicontainer-pern-number"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      systemControls = []
    },
    {
      name         = "api"
      image        = "flickerflak/multicontainer-r2np-server"
      cpu          = 0
      portMappings = []
      essential    = true
      environment = [
        {
          name  = "PGHOST"
          value = "localhost"
        },
        {
          name  = "PGPORT"
          value = "5432"
        },
        {
          name  = "PGUSER"
          value = "postgres"
        },
        {
          name  = "PGDATABASE"
          value = "postgres"
        },
        {
          name  = "PGPASSWORD"
          value = "postgres_password"
        }
      ]
      mountPoints = []
      volumesFrom = []
      dependsOn = [
        {
          containerName = "postgresdb"
          condition     = "START"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/multicontainer-pern-number"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      systemControls = []
    },
    {
      name  = "load-balancer"
      image = "flickerflak/multicontainer-r2np-lb"
      cpu   = 0
      portMappings = [
        {
          name          = "80"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      essential   = true
      environment = []
      mountPoints = []
      volumesFrom = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/multicontainer-pern-number"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      systemControls = []
    },
    {
      name         = "postgresdb"
      image        = "postgres:latest"
      cpu          = 0
      portMappings = []
      essential    = false
      environment = [
        {
          name  = "POSTGRES_PASSWORD"
          value = "postgres_password"
        }
      ]
      mountPoints = []
      volumesFrom = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/multicontainer-pern-number"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      systemControls = []
    }
  ])
  task_role_arn      = "arn:aws:iam::143840105874:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::143840105874:role/ecsTaskExecutionRole"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu    = "1024"
  memory = "3072"
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "multi" {
    name = "multicontainer-service-terraform"
    cluster = aws_ecs_cluster.multi.id
    task_definition = aws_ecs_task_definition.multi.arn
    desired_count = 1
    launch_type = "FARGATE"
    
}
