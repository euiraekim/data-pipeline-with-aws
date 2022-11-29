module "msk_connect" {
  source = "../modules/msk_connect"

  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  msk_cluster_name = "my-msk-cluster"
  kafka_topics = ["User", "Order"]
}
