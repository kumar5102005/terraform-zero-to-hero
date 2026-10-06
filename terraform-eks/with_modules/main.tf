provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../modules/vpc"
  cidr_block = "10.10.0.0/16"
  cluster_name = "demo-eks-cluster"
}

module "eks-cluster"{
    source = "../modules/eks-cluster"
    eks_version = "1.36"
    tags = var.tags
    private_subnet-01 = module.vpc.private_subnet_01
    private_subnet-02 = module.vpc.private_subnet_02
    public_subnet-01 = module.vpc.public_subnet_01
    public_subnet-02 = module.vpc.public_subnet_02

    depends_on = [ module.vpc ]
}

module "node_group" {
  source = "../modules/nodegroup"
  public_subnet-02 = module.vpc.public_subnet_02
  public_subnet-01 = module.vpc.public_subnet_01
  private_subnet-01 = module.vpc.private_subnet_01
  private_subnet-02 = module.vpc.private_subnet_02

  depends_on = [ module.eks-cluster ]
}