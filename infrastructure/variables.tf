variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "gitops-eks-cluster"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "A list of private subnet IDs where the EKS worker nodes will be placed"
  type        = list(string)
}
