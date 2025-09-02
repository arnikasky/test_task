terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "gitops/eks-cluster.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-table"
  }
}
