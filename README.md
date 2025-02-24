# Taxi Booking - Infrastructure & Web Application Setup

## Introduction  

This project serves as a **step-by-step guide** for learning and implementing **DevOps practices** in real-world scenarios. It covers **Infrastructure Automation, CI/CD pipeline setup, and Application Deployment**.  

We use **two repositories** in this project:  

1. **AWS Infrastructure Repository** - Manages AWS infrastructure, including **EC2** and **EKS**, using **Terraform**.  
2. **Web Application Repository** - Contains the sample taxi booking application code, CI/CD pipeline using **Jenkins**, along with the **Dockerfile**, installation **shell scripts**, and **Helm charts**. 

By following this guide, you will gain hands-on experience with **AWS, Terraform, Git, Jenkins, SonarCloud, JFrog, Docker, Kubernetes using Helm, Prometheus, and Grafana**. You will learn how to automate and manage cloud infrastructure while effectively deploying applications on Kubernetes.

## Prerequisites  

Before starting this project, ensure you have the following installed and configured:

### **1. System Requirements**  
- A system with **Windows, macOS, or Linux**  
- Minimum **8GB RAM**
- **Stable internet connection**  

### **2. Required Software & Tools**  
- **Git Bash** – [Download & Install](https://git-scm.com/downloads)
- **AWS CLI** – [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)
- **Terraform** – [Download](https://developer.hashicorp.com/terraform/downloads)
- **VSCode** - [Download & Install](https://code.visualstudio.com/download)

### **3. Cloud Requirements**
- An **AWS account** with IAM permissions for EC2, EKS, S3, and IAM.
- Either use the **default VPC** or create a **custom VPC** with **public internet access**.
- Create a **security group** with **SSH, HTTP, and HTTPS** access.
- If using **EC2 Instance Connect**, open **SSH** to the **EC2 Instance Connect address**. Otherwise, if using **Git Bash**, open **SSH** to your **home network's IP address**.
- Create an **S3** bucket to store the Terraform state file backend.
- Create an **EC2** Instance **Key Pair**.

### **4. Additional Setup**  
- AWS credentials configured on local Machine **(excluding root credentials)** using (`aws configure`).

## Architectural Diagram
- Needed to be added...

## Infrastructure Setup  (Under Process can still be optimised...)

### **Infrastructure Overview**  
This project sets up a **Jenkins Master-Slave architecture** using **Ansible** and **Terraform**. The infrastructure will provision **three EC2 instances** with the following roles:  

- **Ansible Master Server**: Manages Jenkins installation and configuration.  
- **Jenkins Master Server**: Installs **Java and Jenkins**, starts Jenkins, and enables it on boot.  
- **Jenkins Slave Server**: Installs **Java, Maven, and Docker**, configures Docker to start on boot, and connects to the **Jenkins Master**.

Follow these steps to set up the AWS infrastructure using Terraform.  

### **1. Clone the Infrastructure Repository**  
```sh
git clone https://github.com/saishandilya/taxi-booking-terraform-infra.git
cd taxi-booking-terraform-infra
```

### **2. Configure Terraform Variables** 
- Navigate to the **main.tf** file and review the configurations.  
- Create a **terraform.tfvars** file and define your variables as needed.  

#### `terraform.tfvars`  

```hcl
ansible_instance_type = "t2.micro"
jenkins_instance_type = "t2.medium"
instance_key_name     = "devops-training"
security_group_id     = "sg-xxxxxxxxxxxxx"
public_subnet_id      = "subnet-xxxxxxxxxx"
```

#### **Note:**  Place your **EC2 Key Pair** in `modules/ec2/files/` and `terraform.tfvars` in the **main project folder**. These files are excluded in `.gitignore`, so they will not be pushed to GitHub.
The .pem file is required to establish a secure SSH connection between the Ansible Server and Jenkins Master-Slave Servers.