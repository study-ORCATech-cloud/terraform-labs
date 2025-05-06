# Terraform Labs: Cross-Platform Infrastructure Automation Roadmap

Welcome to the **Terraform Labs** project — a parallel track to the Cloud Labs UI & CLI series. These labs focus on automating cloud infrastructure using **Terraform**, the leading Infrastructure as Code (IaC) tool.

This roadmap mirrors the structure of the UI/CLI labs, enabling learners to implement the same scenarios via code and understand how manual tasks can be translated into automation workflows.

---

## 📅 Terraform Lab Roadmap

Each lab uses Terraform to provision the same cloud resources previously handled via UI and CLI. Labs are organized by provider and skill level.

### ✅ Completed Labs (Planned Terraform Equivalents)

#### AWS Terraform Labs
| Lab   | Title                             | Description                                            |
|--------|----------------------------------|--------------------------------------------------------|
| LAB01 | EC2 Instance                      | Launch a VM with Terraform                            |
| LAB02 | S3 Bucket                         | Create and manage S3 bucket and static hosting        |
| LAB03 | IAM Roles and Policies            | Define IAM users, groups, and policies via Terraform  |
| LAB04 | VPC and Security Groups           | Build VPC with subnets, route tables, and NSGs        |
| LAB05 | Load Balancer + Auto Scaling      | Provision ELB + ASG for scalable app infrastructure   |
| LAB06 | CloudWatch Logs and Alarms        | Set up logs, metrics, and alarm notifications         |
| LAB07 | RDS MySQL                         | Create and manage Amazon RDS database                 |
| LAB08 | S3 Lifecycle + Versioning         | Apply lifecycle and versioning policies               |
| LAB09 | Route 53 + Custom Domain          | Manage DNS zones and records with Route 53            |
| LAB10 | Lambda + API Gateway              | Deploy a serverless function with API endpoint        |

#### Azure Terraform Labs
| Lab   | Title                             | Description                                            |
|--------|----------------------------------|--------------------------------------------------------|
| LAB01 | Virtual Machine                   | Deploy VM using Terraform with Azure Provider         |
| LAB02 | Blob Storage                      | Create storage account and blob container             |
| LAB03 | Azure AD + RBAC                   | Manage users, groups, and role assignments            |
| LAB04 | Virtual Network + NSGs            | Configure VNets, subnets, and NSGs                    |
| LAB05 | Load Balancer + VM Scale Set      | Provision Azure LB and auto-scaling VMSS             |
| LAB06 | Monitor + Log Analytics           | Set up Azure Monitor and custom log queries           |
| LAB07 | Azure SQL Database                | Deploy and configure a managed SQL database           |
| LAB08 | Blob Lifecycle Management         | Automate blob transitions using lifecycle rules       |
| LAB09 | Azure DNS + Custom Domain         | Create DNS zone and connect a domain                  |
| LAB10 | Azure Functions + HTTP Trigger    | Deploy serverless function with public URL            |

#### GCP Terraform Labs
| Lab   | Title                             | Description                                            |
|--------|----------------------------------|--------------------------------------------------------|
| LAB01 | Compute Engine VM                 | Launch VM instance using Terraform                    |
| LAB02 | Cloud Storage Bucket              | Create bucket, set permissions, and enable hosting    |
| LAB03 | IAM Roles & Service Accounts      | Define IAM roles and service accounts                 |
| LAB04 | VPC + Firewall Rules              | Set up custom VPC, subnets, and firewall policies     |
| LAB05 | Load Balancer + Instance Group    | Deploy autoscaling group with HTTP LB                |
| LAB06 | Monitoring + Logging              | Enable and configure Stackdriver monitoring           |
| LAB07 | Cloud SQL PostgreSQL              | Create managed PostgreSQL instance with firewall      |
| LAB08 | Object Lifecycle + Retention      | Apply lifecycle rules and retention policy            |
| LAB09 | Cloud DNS + Custom Domain         | Provision DNS records and delegate domain             |
| LAB10 | Cloud Functions + HTTP Trigger    | Deploy function with HTTP trigger and IAM             |

---

### ✅ Advanced AWS Labs

| Lab   | Title                             | Description                                            |
|--------|----------------------------------|--------------------------------------------------------|
| LAB11 | CloudFront CDN                    | Deploy CloudFront distributions with S3 origins, OAI, custom error pages and geo-restrictions |
| LAB12 | ECS with Fargate                  | Create containerized applications with ECS, ECR, Fargate and load balancing |
| LAB13 | DynamoDB with DAX                 | Set up DynamoDB tables with DAX caching, global tables, and fine-grained access control |
| LAB14 | EventBridge, SQS, and SNS         | Build event-driven architectures with event buses, queues, and notification services |
| LAB15 | Cognito with API Gateway          | Implement secure authentication for APIs with Cognito, JWT validation and OAuth flows |
| LAB16 | EKS Kubernetes                    | Deploy managed Kubernetes clusters with worker nodes, networking, storage, and Helm charts |
| LAB17 | Aurora Serverless                 | Create serverless relational databases with auto-scaling, multi-AZ, and Data API access |
| LAB18 | OpenSearch and Kibana             | Build search and analytics solutions with data ingestion pipelines and visualization dashboards |
| LAB19 | Step Functions                    | Orchestrate complex workflows with state machines, error handling, and service integrations |
| LAB20 | AppSync GraphQL API               | Create GraphQL APIs with multiple data sources, resolvers, and real-time subscriptions |

### 🔜 Planned Labs (Terraform Track Extensions)

#### Azure
| Lab   | Title                             | Description                                            |
|--------|----------------------------------|--------------------------------------------------------|
| LAB11 | Azure Front Door                  | Configure global web routing and SSL                  |
| LAB12 | Key Vault + Secret Access         | Manage secrets with RBAC and policy                   |
| LAB13 | AKS Kubernetes Deployment         | Deploy apps on Azure Kubernetes Service               |

#### GCP
| Lab   | Title                             | Description                                            |
|--------|----------------------------------|--------------------------------------------------------|
| LAB11 | Cloud Run                         | Run containerized apps in a fully managed environment |
| LAB12 | BigQuery Analytics                | Set up datasets and run SQL queries                   |
| LAB13 | GKE Kubernetes Deployment         | Deploy container workloads using GKE                  |

---

## 🎯 Lab Format

Each Terraform lab includes:
- `main.tf`, `variables.tf`, and `outputs.tf`
- `README.md` with deployment steps and usage notes
- Cleanup instructions
- Optional enhancements (tags, remote backend, modules)

> All labs follow a real-world use case and are organized for clarity and reusability.

---

## 🎉 Ready to Automate?

Clone the Terraform Labs and start coding your infrastructure:
```bash
git clone https://github.com/study-ORCATech-cloud/terraform-labs.git
```

Then pick a cloud provider and dive in. Happy building!

> Want to contribute? Fork the repo and follow the contribution guide in the README.

---

