variable "eks_version" {
type = string
default = "1.36"
description = "EKS version"
}

variable "cluster_name" {
type = string
default = "demo-eks-cluster"
description = "value of the EKS cluster name"  
}

variable "tags" {
type = map(string)
default = {
    terraform  = "true"
    kubernetes = "demo-eks-cluster"
}
description = "Tags to apply to all resources"
}

variable "public_subnet-01" {
  type = string
  description = "public subnet 01"
}

variable "public_subnet-02" {
  type = string
  description = "public subnet 02"
}

variable "private_subnet-01" {
  type = string
  description = "private subnet 01"
}

variable "private_subnet-02" {
  type = string
  description = "private subnet 02"
}