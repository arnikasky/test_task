variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "gitops-eks-cluster"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}
