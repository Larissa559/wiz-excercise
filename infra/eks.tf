#################################
# EKS Cluster
#################################

resource "aws_eks_cluster" "this" {
  name     = "${var.env}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = var.use_public_subnets ? aws_subnet.public[*].id : aws_subnet.private[*].id
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy
  ]
}

###############################################
# EKS Node Group
###############################################
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.env}-eks-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = var.use_public_subnets ? aws_subnet.public[*].id : aws_subnet.private[*].id

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEKS_CNI_Policy
  ]
}
