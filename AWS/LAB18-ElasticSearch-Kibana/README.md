# LAB18: AWS OpenSearch (Elasticsearch) and Kibana with Terraform

## 📝 Lab Overview

In this lab, you'll use Terraform to deploy and configure **Amazon OpenSearch Service** (formerly Elasticsearch Service) along with Kibana. You'll build a complete search and analytics solution with data ingestion pipelines, visualization dashboards, and alerting capabilities.

---

## 🎯 Learning Objectives

- Deploy an Amazon OpenSearch cluster using Terraform
- Configure secure access with fine-grained access control
- Set up Kibana for data visualization and analysis
- Implement data ingestion pipelines with AWS services
- Create search indices and mappings
- Configure snapshot backups to S3
- Set up alerting and anomaly detection
- Optimize cluster performance and scaling

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of search concepts and analytics
- Familiarity with JSON and RESTful APIs
- Completion of LAB02 (S3 Bucket) and LAB04 (VPC) recommended

---

## 📁 Lab Files

- `main.tf`: OpenSearch domain and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: Domain endpoints and access details
- `terraform.tfvars`: Configuration values
- `lambdas/`: Functions for data ingestion and processing
- `dashboards/`: JSON exports of Kibana dashboards
- `mappings/`: Index mappings and settings
- `sample-data/`: Sample datasets for testing

---

## 🔨 Lab Tasks

1. **Create OpenSearch Domain**:
   - Configure cluster size and instance types
   - Set up dedicated master nodes
   - Configure EBS storage volumes
   - Enable encryption and node-to-node encryption

2. **Implement Secure Access**:
   - Configure VPC access
   - Set up security groups and network ACLs
   - Implement fine-grained access control
   - Create IAM roles and policies

3. **Set up Kibana**:
   - Configure Kibana access
   - Set up authentication and access control
   - Create index patterns
   - Configure default visualizations

4. **Create Data Ingestion Pipeline**:
   - Set up CloudWatch Logs subscription filter
   - Configure Kinesis Firehose delivery stream
   - Implement Lambda functions for transformation
   - Test data ingestion flow

5. **Implement Search Functionality**:
   - Create index templates and mappings
   - Configure analyzers and tokenizers
   - Test search queries and filters
   - Optimize search performance

6. **Create Visualizations and Dashboards**:
   - Build Kibana visualizations
   - Create comprehensive dashboards
   - Set up saved searches
   - Configure Canvas workpads

7. **Set up Alerting and Monitoring**:
   - Configure alerting rules and destinations
   - Implement anomaly detection
   - Set up index lifecycle management
   - Create performance monitoring dashboards

8. **Configure Backup and Recovery**:
   - Set up snapshot repository in S3
   - Configure automated snapshots
   - Test snapshot and restore functionality
   - Implement disaster recovery plan

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully functional OpenSearch cluster
- Secure access with fine-grained permissions
- Kibana dashboards for data visualization
- Automated data ingestion pipeline
- Search capabilities with optimized mappings
- Alerting and anomaly detection
- Backup and disaster recovery strategy

---

## 📚 Advanced Challenges

- Implement cross-cluster search
- Configure SQL support for OpenSearch
- Set up Learning to Rank for search relevancy
- Implement multi-tenancy in Kibana
- Create machine learning jobs for data analysis

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- OpenSearch domain
- EC2 instances for the cluster
- EBS volumes
- S3 snapshot repository
- IAM roles and policies
- Lambda functions
- Kinesis Firehose delivery streams

---

## 📖 Additional Resources

- [OpenSearch Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain)
- [Amazon OpenSearch Service Documentation](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/what-is.html)
- [Kibana User Guide](https://www.elastic.co/guide/en/kibana/current/index.html)
- [OpenSearch Security](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/security.html)
- [Best Practices for Amazon OpenSearch Service](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/bp.html) 