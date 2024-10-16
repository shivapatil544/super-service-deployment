#!/bin/bash

# AWS ECR Repository details
AWS_REGION="your-region" # e.g. us-east-1
ECR_REPO="your-ecr-repo-name" # e.g. super-service
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# Stop any running container with the same name
docker stop super-service || echo "No container to stop"

# Remove old container
docker rm super-service || echo "No container to remove"

# Run Automated Tests
dotnet test ./super-service/super-service.sln
if [ $? -ne 0 ]; then
  echo "Tests failed. Stopping deployment."
  exit 1
fi

# Build the .NET Core Application
dotnet publish ./super-service -c Release -o ./out
if [ $? -ne 0 ]; then
  echo "Build failed. Exiting."
  exit 1
fi

# Build Docker Image
docker build -t super-service:latest ./super-service
if [ $? -ne 0 ]; then
  echo "Docker image build failed. Exiting."
  exit 1
fi

# Login to AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
if [ $? -ne 0 ]; then
  echo "ECR login failed. Exiting."
  exit 1
fi

# Tag the Docker Image for ECR
docker tag super-service:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
if [ $? -ne 0 ]; then
  echo "Failed to tag the Docker image for ECR. Exiting."
  exit 1
fi

# Push Docker Image to ECR
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest
if [ $? -ne 0 ]; then
  echo "Failed to push the Docker image to ECR. Exiting."
  exit 1
fi

# Run the Docker container locally
docker run -d --name super-service -p 8080:80 super-service:latest
if [ $? -ne 0 ]; then
  echo "Failed to run Docker container. Exiting."
  exit 1
fi

echo "Application is running at http://localhost:8080"
