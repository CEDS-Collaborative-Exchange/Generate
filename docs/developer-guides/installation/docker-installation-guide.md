---
description: >-
  This guide provides step-by-step instructions to install Generate on Microsoft
  Azure.
---

# Installing Generate with Docker on Cloud Platforms

This guide will walk you through the process of deploying the Generate application using Docker on either Azure Container Instances or AWS container services. The deployment includes both the Generate.Web frontend application and the Generate.Background service.

## Prerequisites

- Docker Desktop installed and running
- Cloud provider account (Azure or AWS) with appropriate permissions
- OAuth service configured and accessible
- Access to the Generate Docker image repositories
   - Generate.Web: ciididea/generate-web
   - Generate.Background: ciididea/generate-background
## Step 1: Prepare Your Environment

### Generate.Web Configuration

1. Create a new directory for your Generate deployment
2. Create a `docker-compose.web.yml` file with the following content:

```yaml
version: '3'
services:
  generate:
    image: ciididea/generate-web:latest
    ports:
      - 8080:80
    environment:
      - AppSettings__UserStoreType=OAUTH
      - AppSettings__Environment=production
      - AppSettings__ProvisionJobs=false
      - Data__AppDbContextConnection="Server=your-db-server;Database=Generate;User Id=generate_user;Password=your-db-password;"
      - Data__ODSDbContextConnection="Server=your-db-server;Database=ODS;User Id=generate_user;Password=your-db-password;"  
      - Data__StagingDbContextConnection="Server=your-db-server;Database=Staging;User Id=generate_user;Password=your-db-password;" 
      - Data__RDSDbContextConnection="Server=your-db-server;Database=RDS;User Id=generate_user;Password=your-db-password;"
      - AzureAd__Instance="https://login.microsoftonline.com/"
      - AzureAd__Domain="yourdomain.com"
      - AzureAd__TenantId="your-tenant-id"
      - AzureAd__ClientId="your-client-id"
    networks:
      - generate_network
```

### Generate.Background Configuration

3. Create a `docker-compose.background.yml` file with the following content:

```yaml
version: '3'
services:
  generate-background:
      image: ciididea/generate-background:latest
      ports:
        - 5000:80
      networks:
        - generate_network

networks:
  generate_network:
    external: true
```

## Step 2: Configure OAuth

Generate.Web requires OAuth for authentication. You must set up and configure an OAuth service before deployment.

1. Follow the detailed OAuth configuration instructions at: [OAuth Configuration Guide](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation/oauth-configuration)
2. Update the following settings in your `docker-compose.web.yml` file with your OAuth configuration values:
   - `AzureAd__Instance`
   - `AzureAd__Domain`
   - `AzureAd__TenantId`
   - `AzureAd__ClientId`

## Step 3: Configure Database Connections

Update the database connection strings in the `docker-compose.web.yml` file:

```yaml
- Data__AppDbContextConnection="Server=your-db-server;Database=Generate;User Id=generate_user;Password=your-db-password;"
- Data__ODSDbContextConnection="Server=your-db-server;Database=ODS;User Id=generate_user;Password=your-db-password;"  
- Data__StagingDbContextConnection="Server=your-db-server;Database=Staging;User Id=generate_user;Password=your-db-password;" 
- Data__RDSDbContextConnection="Server=your-db-server;Database=RDS;User Id=generate_user;Password=your-db-password;"
```

## Step 4: Deploy to Cloud Container Services

### Azure Deployment

#### Create a Shared Network

First, create a shared Docker network that both services can use:

```bash
docker network create generate_network
```

#### Using Azure Container Instances

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

5. Build and push your Generate.Web container to ACR:
   ```bash
   docker-compose -f docker-compose.web.yml build
   docker tag generate:latest generateregistry.azurecr.io/generate:latest
   docker push generateregistry.azurecr.io/generate:latest
   ```

6. Build and push your Generate.Background container to ACR:
   ```bash
   docker-compose -f docker-compose.background.yml build generate-background
   docker tag generate-background:latest generateregistry.azurecr.io/generate-background:latest
   docker push generateregistry.azurecr.io/generate-background:latest
   ```

7. Create an Azure SQL Server instead of using the SQL container (recommended for production):
   ```bash
   az sql server create --name generate-sql-server --resource-group generate-rg --location eastus --admin-user sqladmin --admin-password YourStrongPasswordHere!
   az sql db create --resource-group generate-rg --server generate-sql-server --name Generate --edition Standard --capacity 10
   ```

8. Create the Azure Container Group for Generate.Web:
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
     --dns-name-label generate-web \
     --environment-variables \
       # Add all environment variables from your docker-compose.web.yml
   ```

9. Create the Azure Container Group for Generate.Background:
   ```bash
   az container create \
     --resource-group generate-rg \
     --name generate-background \
     --image generateregistry.azurecr.io/generate-background:latest \
     --cpu 2 \
     --memory 4 \
     --registry-login-server generateregistry.azurecr.io \
     --registry-username <registry-username> \
     --registry-password <registry-password> \
     --ports 80 \
     --dns-name-label generate-background
   ```

#### Using Azure App Service

For production deployments, consider using Azure App Service with containers:

1. Create Web App for containers for Generate.Web:
   ```bash
   az appservice plan create --name generate-plan --resource-group generate-rg --is-linux
   az webapp create --resource-group generate-rg --plan generate-plan --name generate-web --deployment-container-image-name generateregistry.azurecr.io/generate:latest
   ```

2. Create Web App for containers for Generate.Background:
   ```bash
   az webapp create --resource-group generate-rg --plan generate-plan --name generate-background --deployment-container-image-name generateregistry.azurecr.io/generate-background:latest
   ```

3. Configure environment variables for both services using the Azure Portal

### AWS Deployment

#### Using Amazon ECS

1. Log in to AWS CLI:
   ```bash
   aws configure
   ```

2. Create an Amazon ECR repository for each service:
   ```bash
   aws ecr create-repository --repository-name generate-web
   aws ecr create-repository --repository-name generate-background
   ```

3. Log in to your ECR repository:
   ```bash
   aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com
   ```

4. Build and push your Generate.Web container to ECR:
   ```bash
   docker-compose -f docker-compose.web.yml build
   docker tag generate:latest your-account-id.dkr.ecr.your-region.amazonaws.com/generate-web:latest
   docker push your-account-id.dkr.ecr.your-region.amazonaws.com/generate-web:latest
   ```

5. Build and push your Generate.Background container to ECR:
   ```bash
   docker-compose -f docker-compose.background.yml build generate-background
   docker tag generate-background:latest your-account-id.dkr.ecr.your-region.amazonaws.com/generate-background:latest
   docker push your-account-id.dkr.ecr.your-region.amazonaws.com/generate-background:latest
   ```

6. Create an Amazon RDS instance for SQL Server:
   ```bash
   aws rds create-db-instance \
     --db-instance-identifier generate-sql \
     --db-instance-class db.t3.medium \
     --engine sqlserver-se \
     --master-username admin \
     --master-user-password YourStrongPasswordHere! \
     --allocated-storage 20
   ```

7. Create task definitions for both services (using the AWS console or CLI)

8. Create ECS services using the task definitions (using the AWS console or CLI)

9. Configure networking to allow communication between services

## Step 5: Verify the Deployment

1. Once deployed, access your Generate.Web application at the provided URL
2. Log in using the embedded admin credentials or through your configured OAuth provider
3. Verify that the Generate.Background service is running and accessible from Generate.Web
4. Verify that all features are working correctly

## Troubleshooting

### Azure Troubleshooting

1. **Container connectivity issues**: Ensure both containers can communicate with each other
   ```bash
   az container attach --resource-group generate-rg --name generate-web
   ```

2. **Database connection failures**: Verify your Azure SQL firewall settings allow connections from container IPs

### AWS Troubleshooting

1. **Container connectivity issues**: Check security groups and ensure proper networking between ECS services

2. **Database connection failures**: Ensure RDS security groups allow connections from ECS containers

### General Troubleshooting

1. **Database connection failures**: Test database connectivity from the containers

2. **Background service not running**: Check container logs for errors

3. **Web service cannot connect to background service**: Verify network configurations and service URLs

## Additional Configuration Options

For more advanced configurations, refer to the Generate documentation for:

- **Active Directory Integration**: For environments using AD authentication
- **Metadata Services**: For configuring file metadata updates
- **Database Migrations**: When upgrading from previous versions

For assistance, please contact the Generate support team or refer to the complete documentation.

{% content-ref url="./" %}
[.](./)
{% endcontent-ref %}



