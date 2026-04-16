# Project 2 — Docker → ECR → ECS Fargate with GitHub Actions

A complete CI/CD pipeline that builds a Docker image on every push, pushes it to AWS ECR, and deploys it to ECS Fargate — all provisioned with Terraform.

## Architecture

```
Developer pushes code
        │
        ▼
GitHub Actions workflow triggers
        │
        ├─── terraform plan/apply (if infra changed)
        │
        └─── Build Docker image
                │
                ▼
          Push to AWS ECR
          (with git SHA tag)
                │
                ▼
     Update ECS Task Definition
                │
                ▼
      Deploy to ECS Fargate
      (zero-downtime rolling update)
                │
                ▼
       App live at public IP:80
```

## Prerequisites

1. Terraform >= 1.5.0
2. AWS CLI configured
3. Docker installed (for local testing)
4. GitHub repository with Actions enabled

## Step-by-Step Setup

### Step 1 — Provision infrastructure with Terraform

```bash
cd project2-ecr-ecs

# Initialize
terraform init

# Plan (replace with your AWS account ID)
terraform plan -var="aws_account_id=123456789012"

# Apply
terraform apply -var="aws_account_id=123456789012"
```

After apply, note the outputs:
- `ecr_repository_url` — add to GitHub Secrets as `ECR_REPO_URL`
- `ci_user_access_key_id` — add to GitHub Secrets as `AWS_ACCESS_KEY_ID`
- `ci_user_secret_key` — add to GitHub Secrets as `AWS_SECRET_ACCESS_KEY`

### Step 2 — Add GitHub Secrets

Go to your repo → Settings → Secrets and variables → Actions → New repository secret:

| Secret | Value |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | From terraform output `ci_user_access_key_id` |
| `AWS_SECRET_ACCESS_KEY` | From terraform output `ci_user_secret_key` |
| `AWS_REGION` | `us-east-1` |
| `AWS_ACCOUNT_ID` | Your 12-digit AWS account ID |

### Step 3 — Push code to trigger the pipeline

```bash
git add .
git commit -m "feat: update app"
git push origin main
```

GitHub Actions will automatically:
1. Build the Docker image from `./app/Dockerfile`
2. Tag it with the git commit SHA
3. Push to ECR
4. Update the ECS task definition
5. Deploy to ECS Fargate

### Step 4 — Test locally

```bash
cd app
docker build -t jyothika-app .
docker run -p 8080:80 jyothika-app
# Visit http://localhost:8080
```

### Step 5 — Destroy

```bash
cd project2-ecr-ecs
terraform destroy -var="aws_account_id=123456789012"
```

## CI/CD Flow Explained

```
On every push to main:
  Job 1: build-and-push
    ├── docker build ./app
    ├── docker tag with git SHA
    └── docker push → ECR

  Job 2: deploy (runs after Job 1)
    ├── Download current ECS task definition
    ├── Update image URI in task definition
    └── Deploy new task definition → ECS service
        (ECS does rolling update — zero downtime)

  Job 3: terraform (only if infra files changed)
    ├── terraform init
    └── terraform plan
```

## Customization

| Variable | Default | Description |
|----------|---------|-------------|
| `ecr_repo_name` | `jyothika-app` | ECR repository name |
| `task_cpu` | `256` | Fargate CPU units |
| `task_memory` | `512` | Fargate memory (MB) |
| `desired_count` | `1` | Number of running tasks |
| `container_port` | `80` | App container port |

## Module Structure

```
modules/
├── ecr/    # ECR repository + lifecycle policy
├── iam/    # ECS roles + CI/CD IAM user
└── ecs/    # Cluster, task definition, service, VPC
```

## Security Notes

- CI/CD IAM user has minimal permissions (ECR push + ECS deploy only)
- Secrets stored in GitHub Secrets — never in code
- ECR image scanning enabled on every push
- ECR lifecycle policy keeps only last 10 images (cost control)
- ECS tasks run in public subnet with security group restricting inbound to port 80 only
