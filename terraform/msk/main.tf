module "vpc" {
  source = "../modules/vpc"

  name = "msk"
}

module "msk" {
  source = "../modules/msk"

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}
