module "vpc" {
  source = "../modules/vpc"

  name = "eks-logstash"
  vpc_cidr = "10.1.0.0/16"
  public_subnet_cidrs = ["10.1.1.0/24", "10.1.3.0/24"]
  private_subnet_cidrs = ["10.1.2.0/24", "10.1.4.0/24"]

}
