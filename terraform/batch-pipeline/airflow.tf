module "airflow_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = "airflow-eks"
  cluster_version = "1.22"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids

  eks_managed_node_groups = {
    default_node_group = {
      min_size     = 2
      max_size     = 2
      desired_size = 2
      instance_types = ["t3.medium"]
    }
  }

  node_security_group_additional_rules = {
    airflow_ingress = {
      description              = "airflow ingress"
      protocol                 = "tcp"
      from_port                = 5432
      to_port                  = 5432
      type                     = "ingress"
      cidr_blocks = [module.vpc.vpc_cidr]

    }

    airflow_egress = {
      description              = "airflow egress"
      protocol                 = "-1"
      from_port                = 0
      to_port                  = 0
      type                     = "egress"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }
}
