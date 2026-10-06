variable "cluster_name" {
type = string
default = "demo-eks-cluster"
description = "value of the EKS cluster name"  
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