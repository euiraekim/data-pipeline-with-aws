module "postgresql" {
  source = "../modules/postgresql"

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}
