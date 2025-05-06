# LAB12: AWS ECS with Fargate and Application Load Balancer

## 📝 Lab Overview

In this lab, you'll use Terraform to deploy a containerized application on **Amazon ECS** (Elastic Container Service) using **Fargate** for serverless container management. You'll create a complete infrastructure with load balancing, auto-scaling, and container monitoring.

---

## 🎯 Learning Objectives

- Deploy containerized applications with ECS and Fargate
- Configure task definitions and service discovery
- Set up an Application Load Balancer (ALB) for traffic distribution
- Implement auto-scaling based on CPU and memory metrics
- Register container images with Amazon ECR
- Configure CloudWatch for container monitoring and logging
- Implement blue/green deployments for zero-downtime updates

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Docker installed locally
- Basic understanding of containers and microservices
- Completion of LAB04 (VPC) is recommended

---

## 📁 Lab Files

- `main.tf`: ECS cluster, services, and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: ALB DNS and service ARNs
- `terraform.tfvars`: Configuration values
- `task-definition.json`: ECS task definition template
- `Dockerfile`: Sample application Dockerfile
- `app/`: Sample application code

---

## 🔨 Lab Tasks

1. **Set up ECR Repository**:
   - Create an Elastic Container Registry repository
   - Build and push a sample Docker image

2. **Create ECS Cluster with Fargate**:
   - Configure the VPC, subnets, and security groups
   - Create an ECS cluster for Fargate deployment

3. **Define Task and Container Definitions**:
   - Configure container specifications
   - Set up environment variables and port mappings
   - Configure logging to CloudWatch

4. **Deploy Application Load Balancer**:
   - Create target groups and listeners
   - Configure health checks and routing rules

5. **Create ECS Service**:
   - Deploy the service with desired task count
   - Configure service discovery
   - Link the service to the load balancer

6. **Implement Auto-scaling**:
   - Configure scaling policies based on metrics
   - Set up scheduled scaling for predictable load patterns

7. **Set up Blue/Green Deployment**:
   - Configure CodeDeploy for ECS
   - Implement deployment groups and configurations

8. **Test and Validate**:
   - Access the application through the ALB
   - Verify scaling and monitoring functionality

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully managed containerized application running on ECS Fargate
- Load-balanced traffic distribution across container instances
- Auto-scaling based on demand
- Container images stored in ECR
- Comprehensive monitoring and logging
- CI/CD ready infrastructure with blue/green deployment capability

---

## 📚 Advanced Challenges

- Implement service mesh with AWS App Mesh
- Add container-level security with AWS WAF and Security Groups
- Configure inter-service communication with Service Discovery
- Implement secrets management with AWS Secrets Manager
- Set up CI/CD pipeline with AWS CodePipeline

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- ECS services and tasks
- ECR repository and images
- Application Load Balancer
- Auto-scaling groups
- CloudWatch logs and alarms
- IAM roles and policies

---

## 📖 Additional Resources

- [ECS Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service)
- [AWS Fargate Developer Guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html)
- [Amazon ECR User Guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)
- [ECS Blue/Green Deployments](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-bluegreen.html)
- [ECS Best Practices](https://aws.github.io/aws-eks-best-practices/) 