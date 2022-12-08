module "vpc" {
  source = "../modules/vpc"

  name = "airflow"
  vpc_cidr = "10.4.0.0/16"
  public_subnet_cidrs = ["10.4.1.0/24", "10.4.3.0/24"]
  private_subnet_cidrs = ["10.4.2.0/24", "10.4.4.0/24"]
}
