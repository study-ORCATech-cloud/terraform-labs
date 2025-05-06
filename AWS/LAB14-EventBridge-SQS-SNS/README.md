# LAB14: AWS Event-Driven Architecture with EventBridge, SQS and SNS

## 📝 Lab Overview

In this lab, you'll use Terraform to build a scalable **event-driven architecture** using **Amazon EventBridge**, **SQS**, and **SNS**. You'll create a system that reacts to events from multiple sources, processes them asynchronously, and delivers notifications through various channels.

---

## 🎯 Learning Objectives

- Design and implement an event-driven architecture
- Configure EventBridge rules, patterns, and targets
- Create SQS queues with dead-letter queues and visibility timeout
- Set up SNS topics with multiple subscription types
- Implement event filtering and transformation
- Create custom event buses for domain separation
- Connect Lambda functions to process events
- Configure retry policies and error handling

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of messaging patterns
- Completion of LAB10 (Lambda) is recommended

---

## 📁 Lab Files

- `main.tf`: EventBridge, SQS, SNS, and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: Service endpoints and ARNs
- `terraform.tfvars`: Configuration values
- `lambda/`: Sample Lambda functions for event processing
- `event-patterns/`: JSON event pattern templates

---

## 🔨 Lab Tasks

1. **Create Event Bus and Rules**:
   - Set up default and custom event buses
   - Define event patterns and rules
   - Configure targets for matching events

2. **Implement SQS Queues**:
   - Create standard and FIFO queues
   - Configure dead-letter queues
   - Set up redrive policies
   - Configure encryption and message retention

3. **Set up SNS Topics**:
   - Create SNS topics for notifications
   - Configure subscriptions (email, SMS, Lambda)
   - Set up delivery status logging
   - Implement message filtering

4. **Connect Lambda Functions**:
   - Create functions to process events
   - Configure event source mappings
   - Implement error handling and retries

5. **Create Event Transformations**:
   - Configure input transformers
   - Implement event pattern filtering
   - Map event attributes to target inputs

6. **Implement Cross-Account Event Bus**:
   - Configure resource-based policies
   - Set up cross-account event rules
   - Test cross-account event delivery

7. **Configure Monitoring and Debugging**:
   - Set up CloudWatch metrics and alarms
   - Configure logging for troubleshooting
   - Implement dead-letter queue monitoring

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully functional event-driven architecture
- EventBridge rules configured to route events
- SQS queues for asynchronous processing
- SNS topics delivering notifications to subscribers
- Lambda functions processing events
- Comprehensive monitoring and error handling

---

## 📚 Advanced Challenges

- Implement Schema Registry for event validation
- Create event archive and replay functionality
- Set up cross-region event routing
- Implement event sourcing pattern
- Create API Gateway WebSocket API for real-time notifications

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- EventBridge event buses and rules
- SQS queues (including DLQs)
- SNS topics and subscriptions
- Lambda functions
- IAM roles and policies
- CloudWatch logs and alarms

---

## 📖 Additional Resources

- [EventBridge Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)
- [AWS EventBridge Developer Guide](https://docs.aws.amazon.com/eventbridge/latest/userguide/what-is-amazon-eventbridge.html)
- [Amazon SQS Developer Guide](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html)
- [Amazon SNS Developer Guide](https://docs.aws.amazon.com/sns/latest/dg/welcome.html)
- [Event-Driven Architecture on AWS](https://aws.amazon.com/event-driven-architecture/) 