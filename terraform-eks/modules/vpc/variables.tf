variable "cidr_block" {
type = string
default = "10.10.0.0/16"

}

variable "tags" {
type = map(string)
default = {
    terraform  = "true"
    kubernetes = "demo-eks-cluster"
}
description = "Tags to apply to all resources"
}

variable "cluster_name" {
type = string
default = "demo-eks-cluster"
description = "value of the EKS cluster name"  
}