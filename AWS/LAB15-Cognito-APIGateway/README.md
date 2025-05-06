# LAB15: AWS Cognito with API Gateway and JWT Authentication

## 📝 Lab Overview

In this lab, you'll use Terraform to implement a secure API with **Amazon Cognito** for user authentication and authorization. You'll integrate Cognito with **API Gateway** to create a complete authentication system including user registration, JWT validation, OAuth flows, and fine-grained access control.

---

## 🎯 Learning Objectives

- Create and configure Amazon Cognito User Pools and Identity Pools
- Implement secure API authentication with API Gateway and Cognito Authorizers
- Set up JWT token validation and custom scopes
- Configure OAuth 2.0 flows and social identity providers
- Implement Multi-Factor Authentication (MFA)
- Create resource-based access control policies
- Integrate with Lambda for custom authentication logic

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of authentication concepts
- Familiarity with JWT and OAuth 2.0 principles
- Completion of LAB10 (Lambda) is recommended

---

## 📁 Lab Files

- `main.tf`: Cognito, API Gateway, and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: Service endpoints and client IDs
- `terraform.tfvars`: Configuration values
- `lambda/`: Custom Lambda functions for authentication
- `api-spec/`: OpenAPI specification for API Gateway
- `ui/`: Sample web application for authentication testing

---

## 🔨 Lab Tasks

1. **Create Cognito User Pool**:
   - Configure user pool attributes and policies
   - Set up password requirements and security features
   - Define verification methods (email/SMS)
   - Configure app clients and OAuth settings

2. **Set up Identity Pool**:
   - Link with User Pool for authenticated identities
   - Configure unauthenticated identities (if needed)
   - Set up IAM roles for authenticated/unauthenticated users

3. **Create API Gateway with Cognito Authorizer**:
   - Define API resources and methods
   - Configure Cognito authorizer
   - Set up token validation
   - Create resource policies

4. **Implement User Sign-up and Sign-in Flows**:
   - Configure email/phone verification
   - Set up MFA options
   - Create test users and groups

5. **Configure OAuth and Social Identity Providers**:
   - Set up OAuth scopes and flows
   - Integrate social providers (Google, Facebook, etc.)
   - Configure identity federation

6. **Deploy Lambda Authorizer for Custom Logic**:
   - Implement custom authorization logic
   - Configure Lambda integrations
   - Test custom claims and scopes

7. **Set up Fine-grained Access Control**:
   - Create user groups and roles
   - Implement attribute-based access control
   - Configure resource permissions

8. **Test Authentication Flows**:
   - Test user registration and verification
   - Validate token issuance and validation
   - Verify protected API access

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully configured Cognito User Pool for authentication
- API Gateway with secure Cognito integration
- Working user registration and login flows
- Secure token-based API access
- Fine-grained access control based on user attributes
- Support for social identity providers

---

## 📚 Advanced Challenges

- Implement Custom UI for authentication
- Add step-up authentication for sensitive operations
- Configure risk-based adaptive authentication
- Implement refresh token rotation
- Create custom user migration from legacy systems

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- Cognito User Pools and Identity Pools
- API Gateway APIs and stages
- Lambda functions and authorizers
- IAM roles and policies
- CloudWatch logs

---

## 📖 Additional Resources

- [Cognito Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool)
- [AWS Cognito Developer Guide](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html)
- [API Gateway with Cognito](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html)
- [JWT Authentication Best Practices](https://aws.amazon.com/blogs/mobile/amazon-cognito-user-pools-supports-federation-with-saml/)
- [AWS Security Blog - Cognito](https://aws.amazon.com/blogs/security/tag/amazon-cognito/) 