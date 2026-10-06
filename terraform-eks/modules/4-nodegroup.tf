resource "aws_iam_role" "demo-eks-ng-role" {
  name = "demo-eks-node-group-role"

assume_role_policy = jsonencode({
    Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
        Service = "ec2.amazonaws.com"
    }
    }]
    Version = "2012-10-17"
})
}

resource "aws_iam_role_policy_attachment" "eks-demo-ng-WorkerNodePolicy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
role       = aws_iam_role.demo-eks-ng-role.name 
}

resource "aws_iam_role_policy_attachment" "eks-demo-ng-AmazonEKS_CNI_Policy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
role       = aws_iam_role.demo-eks-ng-role.name 
}


resource "aws_iam_role_policy_attachment" "eks-demo-ng-ContainerRegistryReadOnly" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
role       = aws_iam_role.demo-eks-ng-role.name 
}

resource "aws_eks_node_group" "demo_nodes" {
  cluster_name    = aws_eks_cluster.demo-eks-cluster.name
  node_group_name = "demo-node-group"
  node_role_arn   = aws_iam_role.demo-eks-ng-role.arn
  subnet_ids      = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]

  # Specify Instance Types (can list multiple for flex capacity)
  instance_types = ["c7i-flex.large"]

  # Specify AMI Type (e.g., AL2_x86_64, AL2023_x86_64_STANDARD, BOTTLEROCKET_x86_64)
  ami_type       = "AL2023_x86_64_STANDARD"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-demo-ng-WorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-demo-ng-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-demo-ng-ContainerRegistryReadOnly
  ]
}