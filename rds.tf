
module "rds" {
  source = "../modules/rds"  # Path to the module directory

  allocated_storage       = 20
  engine                  = "sqlserver-ex"
  engine_version          = "15.00.2000.05.v1"
  instance_class          = "db.t2.micro"
  name                    = "my-db-instance"
  db_username             = "admin_username"
  db_password             = "admin_password"
  azure_ad_enabled        = false 
  vpc_id                  = module.vpc.vpc_id 
}

