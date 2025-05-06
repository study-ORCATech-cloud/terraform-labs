# LAB16: AWS Elastic Kubernetes Service (EKS) with Terraform

## 📝 Lab Overview

In this lab, you'll use Terraform to deploy and configure **Amazon EKS** (Elastic Kubernetes Service). You'll create a production-ready Kubernetes cluster with worker nodes, implement networking, storage, monitoring, and deploy sample applications using Kubernetes manifests and Helm charts.

---

## 🎯 Learning Objectives

- Deploy an Amazon EKS cluster using Terraform
- Configure node groups and managed node instances
- Implement Kubernetes networking with AWS VPC CNI
- Set up persistent storage with EBS CSI driver
- Deploy applications using Kubernetes manifests
- Configure monitoring with CloudWatch Container Insights
- Implement cluster autoscaling
- Use Helm charts for application deployment

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- kubectl command-line tool installed
- Helm 3.x installed
- Basic understanding of Kubernetes concepts
- Completion of LAB04 (VPC) is recommended

---

## 📁 Lab Files

- `main.tf`: EKS cluster and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: Cluster endpoints and access details
- `terraform.tfvars`: Configuration values
- `kubernetes/`: Kubernetes manifests for deployments
- `helm/`: Helm chart values and configurations
- `scripts/`: Utility scripts for cluster management

---

## 🔨 Lab Tasks

1. **Create EKS Cluster**:
   - Configure cluster control plane
   - Set up IAM roles for cluster and node groups
   - Deploy in a secure VPC configuration
   - Configure cluster endpoint access

2. **Deploy Node Groups**:
   - Create managed node groups
   - Configure scaling options and instance types
   - Set up node labels and taints
   - Implement Spot instances for cost optimization

3. **Configure Networking**:
   - Set up VPC CNI plugin
   - Configure pod networking
   - Implement security groups
   - Configure cluster service discovery

4. **Set up Storage**:
   - Deploy the EBS CSI driver
   - Create storage classes
   - Configure persistent volume claims
   - Test dynamic provisioning

5. **Deploy Sample Applications**:
   - Deploy microservices applications
   - Implement Kubernetes services
   - Configure ingress controllers
   - Set up blue/green deployments

6. **Set up Monitoring and Logging**:
   - Deploy CloudWatch Container Insights
   - Configure metrics and dashboards
   - Set up log aggregation
   - Implement alerting

7. **Configure Cluster Autoscaler**:
   - Set up the Kubernetes cluster autoscaler
   - Configure scaling policies
   - Test scaling behavior

8. **Implement Helm Deployments**:
   - Deploy applications using Helm
   - Customize chart values
   - Manage Helm releases

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully functional EKS cluster on AWS
- Worker nodes deployed and managed with node groups
- Networking configured for pod and service communication
- Sample applications running on Kubernetes
- Monitoring and logging for cluster operations
- Automatic scaling based on demand
- Applications deployed via Helm charts

---

## 📚 Advanced Challenges

- Implement GitOps with Flux or ArgoCD
- Configure Istio service mesh
- Set up pod security policies
- Implement AWS Load Balancer Controller
- Configure federated identity with EKS

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- EKS cluster and node groups
- Load balancers created by services
- EC2 instances from node groups
- EBS volumes from persistent volumes
- IAM roles and policies
- CloudWatch logs and alarms

---

## 📖 Additional Resources

- [EKS Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)
- [AWS EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Helm Documentation](https://helm.sh/docs/) 