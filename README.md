## Getting Started

Follow the steps below to set up your environment and deploy the EKS cluster, Helm chart and ArgoCD.

### Prerequisites

Before you begin, ensure you have the following installed and configured on your local machine:

* **Terraform**: The tool used to provision the infrastructure.
* **AWS CLI**: The command-line interface for interacting with AWS services. This is required for authentication and for the `update-kubeconfig` command.
* **`kubectl`**: The command-line tool for interacting with your Kubernetes clusters.
* **`helm`**: The package manager for Kubernetes.

### Tooling & Versions

To ensure compatibility and a smooth deployment, please use the following versions (or newer):

* **`kubectl`**: A version compatible with the EKS cluster's Kubernetes version. For example, if the EKS cluster is running Kubernetes v1.28, a `kubectl` version of 1.28 is recommended.
* **`helm`**: A recent version of Helm 3.

### AWS Credentials

You must have valid AWS credentials configured for the `eu-central-1` region. This can be done in one of the following ways:

* **Environment Variables**:
    ```bash
    export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
    export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
    export AWS_REGION="eu-central-1"
    ```

* **AWS Credentials File (`~/.aws/credentials`)**:
    ```ini
    [default]
    aws_access_key_id = YOUR_ACCESS_KEY
    aws_secret_access_key = YOUR_SECRET_KEY
    region = eu-central-1
    ```
    
* **AWS Profile**: If you are using a specific named profile, ensure you set the `AWS_PROFILE` environment variable:
    ```bash
    export AWS_PROFILE="my-eks-profile"
    ```

* **Kube Config**: Project is prepared to deploy and add EKS credentials to `.kube/config` file

## Configuration

1.  **Prepare your AWS Environment:**

    -   Create an S3 bucket for your Terraform remote state and a DynamoDB table for state locking (e.g., `terraform-state-bucket` and `terraform-lock-table`).

2.  **Provision the EKS Cluster:**

    -   Run `terraform init`, `terraform plan`, and `terraform apply` in directory `infrastructure`. This will provision VPC, subnets, and EKS cluster and install ArgoCD, and add EKS credentials to `.kube/config` file.

3.  **Set up GitOps:**
 
    -   Create a new Git repository (e.g., on GitHub or GitLab).

    -   Copy the `helm-chart` directory and the `argocd-manifests` directory into this new repository.

    -   Update the `argocd-manifests/tes-app.yaml` file to use your new Git repository URL and branch name.

    -   Commit and push your changes to the `master` branch.

    -   Finally, tell ArgoCD to deploy your app by applying the `test-app.yaml` manifest: `kubectl apply -f argocd-manifests/app.yaml`

    -   Verify sync: run `kubectl get applications -n argocd` and check workloads: run `kubectl get pods,svc -n nb-challenge`

ArgoCD will now automatically detect the manifest in your Git repository and deploy the `test-app` Helm chart to your EKS cluster. Any future changes you make to the Helm chart and push to Git will be automatically synced by ArgoCD.