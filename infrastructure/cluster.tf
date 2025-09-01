terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = aws_vpc.main.id
  subnet_ids = [for subnet in aws_subnet.aws_subnet : subnet.id]

  eks_managed_node_groups = {
    default_node_group = {
      capacity_type  = "SPOT"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    GitOps      = "True"
  }
  depends_on = [
    aws_vpc.main,
    aws_subnet.aws_subnet
  ]
}

resource "null_resource" "kubectl_config" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-central-1 --name var.cluster.name"
  }
  depends_on = [
    module.eks_cluster
  ]
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks_cluster.cluster_certificate_authority_data
}

output "config_map_aws_auth" {
  description = "A config map to authenticate the IAM role with EKS"
  value       = module.eks_cluster.aws_auth_configmap_yaml
}
