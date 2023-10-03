# RDS MSSQL using Azure AD Module

resource "aws_db_instance" "my_db_instance_azure_ad" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = var.name
  }

  # Enable Azure AD authentication
  enabled_cloudwatch_logs_exports       = ["audit"]
  iam_database_authentication_enabled  = true
  monitoring_interval                  = 0
  performance_insights_enabled         = false
  skip_upgrade                         = false
  enable_cloudwatch_logs_exports       = ["audit"]
  iam_roles                            = [var.azure_ad_role_id]
}

resource "aws_secretsmanager_secret" "azure_ad_secret" {
  name = "my-azure-ad-secret"
}

resource "aws_secretsmanager_secret_version" "azure_ad_secret_version" {
  secret_id     = aws_secretsmanager_secret.azure_ad_secret.id
  secret_string = jsonencode({
    username = var.azure_ad_admin_username
    password = var.azure_ad_admin_password
  })
}

resource "aws_db_instance_role_association" "azure_ad_association" {
  db_instance_identifier = aws_db_instance.my_db_instance_azure_ad.id
  feature_name           = "MicrosoftIAM"
  role_arn               = var.azure_ad_role_arn
}

# ... Define security groups and CloudWatch Logs resources ...

# Create an IAM role for Azure AD authentication
resource "aws_iam_role" "azure_ad_role" {
  name = "my-azure-ad-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity",
      Effect = "Allow",
      Principal = {
        Federated = "cognito-identity.amazonaws.com"
      },
      Condition = {
        StringEquals = {
          "cognito-identity.amazonaws.com:aud" = "us-east-1:your-cognito-identity-pool-id"
        }
      }
    }]
  })
}
# Attach policies to the Azure AD role as needed
resource "aws_iam_policy_attachment" "attach_azure_ad_policies" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role       = aws_iam_role.azure_ad_role.name
}
# Your security group configuration (modify as needed)
resource "aws_security_group" "mssql_azure_ad_security_group" {
  name        = "mssql-azure-ad-security-group"
  description = "MSSQL Azure AD security group"
  vpc_id      = aws_vpc.my_vpc.id  

  ingress {
    from_port = 1433
    to_port = 1433
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
    Name = "mssql_azure_ad_security_group"
  }
}
# Create a CloudWatch Log Group for RDS
resource "aws_cloudwatch_log_group" "rds_logs" {
  name = "RDSLogs"
}
# Create a CloudWatch Logs Export Task
resource "aws_cloudwatch_log_stream" "rds_export" {
  log_group_name           = aws_cloudwatch_log_group.rds_logs.name
  destination_arn          = aws_db_instance.my_db_instance.arn
  destination_data_format = "json"
}
resource "aws_security_group" "rds_security_group" {
  vpc_id = var.vpc_id

  # Define inbound rules for RDS
  # Allow incoming traffic on port 1433 (SQL Server) from Lambda's security group

  # Allow traffic from Lambda's security group
  ingress {
    from_port   = 1433  # The port your RDS instance listens on (change if necessary)
    to_port     = 1433  # The same port as from_port
    protocol    = "tcp"
    security_groups = [aws_security_group.lambda_security_group.id]
  }

  # ... Other rules or configurations ...

  tags = {
    Name = "my_security_group"
  }
}

