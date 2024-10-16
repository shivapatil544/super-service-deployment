# Super Service Deployment

This repository contains the solution to the DevOps technical task. It includes an automated deployment of a .NET Core Web API (Part 1) and documentation for a secure Kubernetes cluster setup (Part 2).

## Part 1: Automated Deployment

### Prerequisites

Ensure you have the following installed:
- [.NET Core SDK](https://dotnet.microsoft.com/download/dotnet-core)
- [Docker](https://www.docker.com/get-started)
- [AWS CLI](https://aws.amazon.com/cli/) - configured with access to Amazon ECR

### Instructions

1. Clone this repository:

    ```bash
    git clone https://github.com/your-username/super-service-deployment.git
    cd super-service-deployment
    ```

2. Ensure Docker is running on your machine and AWS CLI is properly configured.

3. Run the deployment script:

    ```bash
    chmod +x deploy.sh
    ./deploy.sh
    ```

4. The application will be available at: `http://localhost:8080`

### AWS ECR Deployment

The script pushes the Docker image to AWS ECR. Ensure that you have an ECR repository set up by running:

```bash
aws ecr create-repository --repository-name your-ecr-repo-name --region your-region
# super-service-deployment
