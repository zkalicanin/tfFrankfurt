module "rds_azure_ad" {
  source = "./modules/rds_azure_ad"  # Path to the module directory

  allocated_storage      = 20
  engine                 = "sqlserver-ex"
  engine_version         = "15.00.2000.05.v1"
  instance_class         = "db.t2.micro"
  name                   = "my-azure-ad-db-instance"
  db_username            = "admin_username"
  db_password            = "admin_password"
  security_group_id      = aws_security_group.mssql_azure_ad_security_group.id
  azure_ad_admin_username = "azure_ad_admin_username"
  azure_ad_admin_password = "azure_ad_admin_password"
  azure_ad_role_id       = aws_iam_role.azure_ad_role.id
  azure_ad_role_arn      = aws_iam_role.azure_ad_role.arn
  azure_ad_enabled       = false
  vpc_id                 = module.vpc.vpc_id
  # Define other module variables as needed
}