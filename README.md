# Terraform Labs Repository

A hands-on, code-first collection of cloud infrastructure labs built with **Terraform** — enabling you to automate the provisioning of real-world resources across **AWS**, **Azure**, and **GCP**.

This repository is the Terraform-based counterpart to our [UI & CLI Cloud Labs](https://github.com/study-ORCATech-cloud/cloud-labs), offering a practical way to transition from manual tasks to Infrastructure as Code (IaC).

---

## 📦 About This Repository

These labs are designed for learners who want to:
- Understand **how Terraform automates cloud provisioning**
- Translate manual tasks into **declarative, reusable code**
- Build **modular and scalable** cloud infrastructure

Labs match the use cases of the Cloud Labs UI/CLI track but are fully implemented using Terraform.

---

## 📁 Repository Structure

```bash
terraform-labs/
│
├── AWS/                        # AWS Terraform labs
│   ├── LAB01-EC2-Instance/
│   ├── LAB02-S3-Bucket/
│   └── ...
│
├── Azure/                      # Azure Terraform labs
│   ├── LAB01-Virtual-Machine/
│   ├── LAB02-Storage-Account/
│   └── ...
│
├── GCP/                        # GCP Terraform labs
│   ├── LAB01-Compute-Engine/
│   ├── LAB02-Cloud-Storage/
│   └── ...
│
└── Common/                     # Shared modules or documentation
    └── Provider-Setup.md       # Setup instructions for each cloud
```

Each lab folder includes:
- `main.tf`, `variables.tf`, `outputs.tf`
- `README.md` with purpose, instructions, and cleanup
- Optional: `terraform.tfvars.example`

---

## 🧰 Prerequisites

To complete these labs, you’ll need:
- Terraform (v1.3+ recommended): [Install Terraform](https://developer.hashicorp.com/terraform/downloads)
- A cloud account for AWS, Azure, or GCP
- Credentials configured in your shell (or use `terraform.tfvars`)

---

## 🚀 How to Use These Labs

1. Clone this repository:
   ```bash
   git clone https://github.com/<your-org>/terraform-labs.git
   cd terraform-labs
   ```
2. Navigate to a lab folder (e.g., `AWS/LAB01-EC2-Instance/`)
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Preview and apply the configuration:
   ```bash
   terraform plan
   terraform apply
   ```
5. Follow the included `README.md` for full steps, validation, and cleanup.

---

## 📈 Learning Progression

Labs are designed to build IaC skills incrementally:

- **Beginner**: Launch compute instances, configure basic storage
- **Intermediate**: Networking, IAM, monitoring, scalable systems
- **Advanced**: Serverless, multi-region, Kubernetes, automation

---

## 🌐 Lab Roadmap

Check the [Terraform Labs Roadmap](./ROADMAP.md) for a full list of completed and upcoming labs for each cloud provider.

---

## 🤝 Contributing

We welcome Terraform modules, lab additions, bug fixes, and documentation updates:

1. Fork the repo
2. Create a branch (`feature/lab-new-topic`)
3. Add the lab under the correct cloud provider
4. Submit a pull request with a clear explanation

---

## 🙏 Acknowledgments

- Terraform by HashiCorp
- AWS, Azure, and GCP official provider plugins
- Community contributors and DevOps engineers

---

## 🌟 Automate with Confidence

Master cloud provisioning the modern way. These Terraform labs will help you write infrastructure that is **modular**, **versioned**, and **repeatable** — all while mirroring real-world cloud practices.

Happy building! ☁️

