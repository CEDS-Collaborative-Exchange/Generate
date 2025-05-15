---
description: >-
  This guide provides step-by-step instructions to install Generate on Microsoft
  Azure.
---
# Installing Generate.Web with Docker on Cloud Platforms

This guide will walk you through the process of deploying the Generate.Web application using Docker on either Azure Container Instances or AWS container services.

## Prerequisites

- Docker Desktop installed and running
- Cloud provider account (Azure or AWS) with appropriate permissions
- OAuth service configured and accessible
- Access to the Generate Docker image repository

## Step 1: Prepare Your Environment

1. Create a new directory for your Generate deployment
2. Create a `docker-compose.yml` file with the following content:

```yaml
version: '3'
services:
  generate:
    image: generate/generate.web:latest
    ports:
      - 8080:80
    environment:
      - AppSettings__UserStoreType=OAUTH
      - AppSettings__Environment=production
      - AppSettings__BackgroundUrl="https://generate-background-test.aem-tx.com"
      - AppSettings__BackgroundAppPath="D:\\Apps\\generate.background.test"
      - Data__AppDbContextConnection="Server=your-db-server;Database=Generate;User Id=generate_user;Password=your-db-password;"
      - Data__ODSDbContextConnection="Server=your-db-server;Database=ODS;User Id=generate_user;Password=your-db-password;"  
      - Data__StagingDbContextConnection="Server=your-db-server;Database=Staging;User Id=generate_user;Password=your-db-password;" 
      - Data__RDSDbContextConnection="Server=your-db-server;Database=RDS;User Id=generate_user;Password=your-db-password;"
      - AzureAd__Instance="https://login.microsoftonline.com/"
      - AzureAd__Domain="yourdomain.com"
      - AzureAd__TenantId="your-tenant-id"
      - AzureAd__ClientId="your-client-id"
```

## Step 2: Configure OAuth

Generate.Web requires OAuth for authentication. You must set up and configure an OAuth service before deployment.

1. Follow the detailed OAuth configuration instructions at: [OAuth Configuration Guide](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation/oauth-configuration)
2. Update the following settings in your `docker-compose.yml` file with your OAuth configuration values:
   - `AzureAd__Instance`
   - `AzureAd__Domain`
   - `AzureAd__TenantId`
   - `AzureAd__ClientId`

## Step 3: Configure Database Connections

Update the database connection strings in the `docker-compose.yml` file:

```yaml
- Data__AppDbContextConnection="Server=your-db-server;Database=Generate;User Id=generate_user;Password=your-db-password;"
- Data__ODSDbContextConnection="Server=your-db-server;Database=ODS;User Id=generate_user;Password=your-db-password;"  
- Data__StagingDbContextConnection="Server=your-db-server;Database=Staging;User Id=generate_user;Password=your-db-password;" 
- Data__RDSDbContextConnection="Server=your-db-server;Database=RDS;User Id=generate_user;Password=your-db-password;"
```

## Step 4: Deploy to Cloud Container Services

### Azure Deployment

#### Using Azure CLI

1. Log in to Azure CLI:
   ```bash
   az login
   ```

2. Create a resource group if you don't have one:
   ```bash
   az group create --name generate-rg --location eastus
   ```

3. Create an Azure Container Registry or use an existing one:
   ```bash
   az acr create --resource-group generate-rg --name generateregistry --sku Basic
   ```

4. Log in to your container registry:
   ```bash
   az acr login --name generateregistry
   ```

5. Build and push your container to ACR:
   ```bash
   docker-compose build
   docker tag generate_generate:latest generateregistry.azurecr.io/generate:latest
   docker push generateregistry.azurecr.io/generate:latest
   ```

6. Create the Azure Container Instance:
   ```bash
   az container create \
     --resource-group generate-rg \
     --name generate-web \
     --image generateregistry.azurecr.io/generate:latest \
     --cpu 2 \
     --memory 4 \
     --registry-login-server generateregistry.azurecr.io \
     --registry-username <registry-username> \
     --registry-password <registry-password> \
     --ports 80 \
     --environment-variables \
       AppSettings__UserStoreType=OAUTH \
       AppSettings__Environment=production \
       # Add all other environment variables from your docker-compose.yml
   ```

#### Using Azure Portal

1. Navigate to the Azure Portal
2. Search for "Container Instances" and select "Create"
3. Fill in the basics (subscription, resource group, container name)
4. For the image source, select "Azure Container Registry" and choose your registry
5. Select your image and tag
6. Configure networking options (public IP)
7. Under "Advanced" tab, add all environment variables from your docker-compose.yml
8. Review and create the container instance

### AWS Deployment

#### Using AWS CLI

1. Log in to AWS CLI:
   ```bash
   aws configure
   ```

2. Create an Amazon ECR repository:
   ```bash
   aws ecr create-repository --repository-name generate
   ```

3. Log in to your ECR repository:
   ```bash
   aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com
   ```

4. Build and push your container to ECR:
   ```bash
   docker-compose build
   docker tag generate_generate:latest your-account-id.dkr.ecr.your-region.amazonaws.com/generate:latest
   docker push your-account-id.dkr.ecr.your-region.amazonaws.com/generate:latest
   ```

5. Create an ECS Task Definition (save as task-definition.json):
   ```json
   {
     "family": "generate-task",
     "networkMode": "awsvpc",
     "executionRoleArn": "arn:aws:iam::your-account-id:role/ecsTaskExecutionRole",
     "containerDefinitions": [
       {
         "name": "generate",
         "image": "your-account-id.dkr.ecr.your-region.amazonaws.com/generate:latest",
         "essential": true,
         "portMappings": [
           {
             "containerPort": 80,
             "hostPort": 80,
             "protocol": "tcp"
           }
         ],
         "environment": [
           {"name": "AppSettings__UserStoreType", "value": "OAUTH"},
           {"name": "AppSettings__Environment", "value": "production"}
           // Add all other environment variables from your docker-compose.yml
         ],
         "logConfiguration": {
           "logDriver": "awslogs",
           "options": {
             "awslogs-group": "/ecs/generate-task",
             "awslogs-region": "your-region",
             "awslogs-stream-prefix": "ecs"
           }
         }
       }
     ],
     "requiresCompatibilities": ["FARGATE"],
     "cpu": "1024",
     "memory": "2048"
   }
   ```

6. Register the task definition:
   ```bash
   aws ecs register-task-definition --cli-input-json file://task-definition.json
   ```

7. Create an ECS Service:
   ```bash
   aws ecs create-service \
     --cluster your-cluster \
     --service-name generate-service \
     --task-definition generate-task \
     --desired-count 1 \
     --launch-type FARGATE \
     --network-configuration "awsvpcConfiguration={subnets=[subnet-12345678],securityGroups=[sg-12345678],assignPublicIp=ENABLED}"
   ```

#### Using AWS Console

1. Navigate to the AWS Management Console
2. Go to Elastic Container Registry (ECR)
3. Create a new repository named "generate"
4. Follow the push commands displayed in the console to push your Docker image
5. Go to Elastic Container Service (ECS)
6. Create a new Task Definition (Fargate)
7. Add your container details including the ECR image URI
8. Add all environment variables from your docker-compose.yml
9. Configure CPU and memory requirements (suggested: 1 vCPU, 2GB memory)
10. Create a new ECS Service using your task definition
11. Configure networking (VPC, subnets, security groups)
12. Review and create the service

## Step 5: Verify the Deployment

1. Once deployed, access your Generate.Web application at the provided cloud service URL
2. Log in using the embedded admin credentials or through your configured OAuth provider
3. Verify that all features are working correctly

## Troubleshooting

If you encounter issues with your deployment, check the following:

### Azure Troubleshooting

1. **Container not starting**: Check container logs
   ```bash
   az container logs --resource-group generate-rg --name generate-web
   ```

2. **Authentication issues**: Verify your OAuth configuration is correct and the service is accessible

### AWS Troubleshooting

1. **Container not starting**: Check CloudWatch logs
   ```bash
   aws logs get-log-events --log-group-name "/ecs/generate-task" --log-stream-name <log-stream-name>
   ```

2. **Authentication issues**: Verify your OAuth configuration is correct and the service is accessible

### General Troubleshooting

1. **Database connection failures**: Ensure your database connection strings are correct and the database server is accessible from your cloud provider

2. **Metadata file issues**: Check that the metadata file locations are correctly specified and accessible

## Additional Configuration Options

For more advanced configurations, refer to the Generate documentation for:

- **Active Directory Integration**: For environments using AD authentication
- **Metadata Services**: For configuring file metadata updates
- **Database Migrations**: When upgrading from previous versions

For assistance, please contact the Generate support team or refer to the complete documentation.
{% content-ref url="./" %}
[.](./)
{% endcontent-ref %}



