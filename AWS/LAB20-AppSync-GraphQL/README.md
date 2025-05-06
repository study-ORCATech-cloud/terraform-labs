# LAB20: AWS AppSync GraphQL API with Terraform

## 📝 Lab Overview

In this lab, you'll use Terraform to build a complete **GraphQL API** using **AWS AppSync**. You'll connect to multiple data sources, implement resolvers, configure authentication and authorization, and build a fully functional API with subscriptions for real-time data updates.

---

## 🎯 Learning Objectives

- Deploy an AWS AppSync GraphQL API using Terraform
- Configure multiple data sources (DynamoDB, Lambda, HTTP)
- Implement resolvers with mapping templates
- Set up authentication and authorization
- Create GraphQL schema with queries, mutations, and subscriptions
- Implement real-time data with subscriptions
- Configure caching and logging
- Test and monitor GraphQL API performance

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of GraphQL concepts
- Familiarity with JSON and VTL (Velocity Template Language)
- Completion of LAB13 (DynamoDB) recommended

---

## 📁 Lab Files

- `main.tf`: AppSync API and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: API endpoints and keys
- `terraform.tfvars`: Configuration values
- `schema/`: GraphQL schema definitions
- `resolvers/`: VTL mapping templates for resolvers
- `lambda/`: Lambda functions for data sources
- `test-queries/`: Sample GraphQL operations for testing

---

## 🔨 Lab Tasks

1. **Create AppSync API**:
   - Define GraphQL schema with types, queries, mutations, and subscriptions
   - Configure API key or other authentication mechanisms
   - Set up logging and monitoring

2. **Configure Data Sources**:
   - Create DynamoDB tables for persistent storage
   - Set up Lambda functions for complex operations
   - Configure HTTP endpoints for external services
   - Set up appropriate IAM roles and policies

3. **Implement Resolvers**:
   - Create unit resolvers for basic operations
   - Implement pipeline resolvers for complex operations
   - Write request and response mapping templates
   - Test resolver functionality

4. **Set up Authentication and Authorization**:
   - Configure API key authentication
   - Implement Cognito User Pool integration
   - Set up IAM authentication
   - Create fine-grained access control

5. **Implement Subscriptions**:
   - Create subscription fields in schema
   - Configure real-time data sources
   - Implement subscription resolvers
   - Test WebSocket connections

6. **Configure Caching**:
   - Set up AppSync caching
   - Configure TTL and cache invalidation
   - Measure performance improvements
   - Implement cache strategies

7. **Add Monitoring and Logging**:
   - Set up CloudWatch metrics and logs
   - Create alarms for API performance
   - Implement tracing with X-Ray
   - Configure error logging

8. **Test and Optimize**:
   - Create test scenarios for queries, mutations, and subscriptions
   - Measure and optimize performance
   - Implement error handling
   - Test concurrent operations

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully functional GraphQL API with AWS AppSync
- Data persistence with multiple data sources
- Real-time data capabilities using subscriptions
- Secure authentication and authorization
- Optimized performance with caching
- Comprehensive monitoring and logging
- A reusable pattern for future GraphQL APIs

---

## 📚 Advanced Challenges

- Implement batching and dataloader patterns
- Create custom authentication with Lambda authorizers
- Implement schema stitching for multiple APIs
- Add a websocket API for bidirectional communication
- Create a comprehensive frontend application using the API

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- AppSync API
- DynamoDB tables
- Lambda functions
- CloudWatch logs and alarms
- API keys
- IAM roles and policies
- Cognito User Pools (if created)

---

## 📖 Additional Resources

- [AppSync Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appsync_graphql_api)
- [AWS AppSync Developer Guide](https://docs.aws.amazon.com/appsync/latest/devguide/welcome.html)
- [GraphQL Documentation](https://graphql.org/learn/)
- [AppSync Resolver Mapping Template Reference](https://docs.aws.amazon.com/appsync/latest/devguide/resolver-mapping-template-reference.html)
- [Building Real-Time Applications with AppSync](https://aws.amazon.com/blogs/mobile/building-real-time-applications-with-aws-appsync/) 