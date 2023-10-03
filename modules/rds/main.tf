

resource "aws_security_group" "mssql_security_group" {
  name        = "mssql_security_group"
  description = "mssql_security_group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust the CIDR blocks as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust the CIDR blocks as needed
  }

  tags = {
    Name = "my_security_group"
  }
}

resource "aws_rds_" "name" {
  
}

resource "aws_db_instance" "mssql_instance" {
  allocated_storage       = 20
  engine                  = "sqlserver-ex"
  engine_version          = "15.00.2000.05.v1"
  instance_class          = "db.t2.micro"
  name                    = "mydb"
  username                = "admin"
  password                = "admin123"
  parameter_group_name    = "default.sqlserver-ex-15.00"
  skip_final_snapshot     = true
  backup_retention_period = 7
  vpc_security_group_ids  = [aws_security_group.mssql_security_group.id]
  vpc_id                  = var.vpc_id

  # Disable Azure AD
  iam_database_authentication_enabled = false

  monitoring_interval    = 60  # Interval for CloudWatch metrics (in seconds)
  performance_insights_enabled = false

  # Specify the IAM role for CloudWatch Logs publishing
  cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  monitoring_role_arn    = aws_iam_role.rds_cloudwatch_logs_role.arn

  tags = {
    Name = "my_mssql_instance"
  }
}

resource "aws_iam_role" "rds_cloudwatch_logs_role" {
  name = "rds-cloudwatch-logs-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "RdsCloudWatchLogsPolicy"
  description = "IAM policy to allow RDS to publish logs to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_attachment" {
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
  role       = aws_iam_role.rds_cloudwatch_logs_role.name
}

resource "aws_cloudwatch_log_group" "mssql_logs" {
  name = "/aws/rds/my_mssql_instance"  # Adjust as needed
}

resource "aws_cloudwatch_log_stream" "mssql_log_stream" {
  name           = "my_mssql_instance_logs"  # Adjust as needed
  log_group_name = aws_cloudwatch_log_group.mssql_logs.name
}


