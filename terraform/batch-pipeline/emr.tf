module "emr" {
  source = "../modules/emr"

  vpc_id = module.vpc.vpc_id
  vpc_cidr = module.vpc.vpc_cidr
  public_subnet_ids = module.vpc.public_subnet_ids
}
