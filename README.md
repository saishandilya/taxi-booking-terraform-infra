# Taxi Booking - Infrastructure & Application Setup

## Introduction  

This project serves as a **step-by-step guide** for learning and implementing **DevOps practices** in real-world scenarios. It covers **Infrastructure Automation, CI/CD pipeline setup, and Application Deployment**.  

We use **two repositories** in this project:  

1. **AWS Infrastructure Repository** - Manages AWS infrastructure, including **EC2** and **EKS**, using **Terraform**.  
2. **Application Repository** - Contains the sample taxi booking application code, CI/CD pipeline using **Jenkins**, along with the **Dockerfile**, installation **shell scripts**, and **Helm charts**. 

By following this guide, you will gain hands-on experience with **AWS, Terraform, Git, Jenkins, SonarCloud, JFrog, Docker, Kubernetes using Helm, Prometheus, and Grafana**. You will learn how to automate and manage cloud infrastructure while effectively deploying applications on Kubernetes.

## Prerequisites  

Before starting this project, ensure you have the following installed and configured:

### **1. System Requirements**  
- A system with **Windows, macOS, or Linux**.
- Minimum **8GB RAM**.
- **Stable internet connection**.

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
- **Jenkins Slave Server**: Installs **Java, Maven, AWS Cli and Docker**, configures Docker to start on boot, and connects to the **Jenkins Master**.

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
instance_key_name     = "devops-master-key"
security_group_id     = "sg-xxxxxxxxxxxxx"
public_subnet_id      = "subnet-xxxxxxxxxx"
```

#### **Note:**  Place your **EC2 Key Pair** in `modules/ec2/files/` and `terraform.tfvars` in the **main project folder**. These files are excluded in `.gitignore`, so they will not be pushed to GitHub.
The .pem file is required to establish a secure SSH connection between the Ansible Server and Jenkins Master-Slave Servers.

### **3. Initialize and Apply Terraform** 

Run the following commands to initialize Terraform and deploy the infrastructure:

```hcl
terraform init
terraform validate
terraform plan -out=ec2.plan
terraform apply --auto-approve
```

### **4. Jenkins Portal Setup**  

1. Open Jenkins in your browser: `http://<jenkins-master-public-ip>:8080` and Enter the **Administrator password** when prompted.
2. Log in to the Jenkins master server and retrieve the `initialAdminPassword` using the below command:
    ```sh
    sudo cat /var/lib/jenkins/secrets/initialAdminPassword
    ```
    Copy and paste the password into the Jenkins portal.
3. Jenkins will prompt to either `Install Suggested Plugins` or `Select Plugins Manually`. Choose **Install Suggested Plugins** for a standard setup.

4. **Create Admin User**  
   - Provide the following details:  
     - **Username**  
     - **Password**  
     - **Full Name**  
     - **Email Address**  
   - Click **Save and Continue**.  

5. Set the Jenkins URL to default (e.g., `http://<jenkins-master-public-ip>:8080`). If using a domain-based setup, update it accordingly (e.g., `http://jenkins.example.com`). Click **Save and Finish**.

6. Jenkins setup is now complete! Click **Start using Jenkins** to access the dashboard.


### **5. Configure Jenkins Master-Slave Setup**

1. **Add SSH Credentials:** 
    - Go to **Manage Jenkins → Manage Credentials**, select **Global**, and click **Add Credentials**.
    - Select **Kind**: **SSH Username with Private Key** and provide the following details:
        - **ID**: `master-slave`  
        - **Description**: SSH PEM key to access the Slave Node from the Master
        - **Username**: `ubuntu`
        - **Private Key**:
            - Select **Enter Directly**
            - Copy and paste the contents of `<ec2-instance.pem>` key
        - Click **Save**.  

2. **Add and Configure Slave Node:**
    - Navigate to **Manage Jenkins → Nodes** and click on **New Node**.
    - Enter a **Node Name** (e.g., `slave-node`), select **Permanent Agent**, and click **Create**.  
    - Configure the new node with the following settings:  
        - **Description**: (Optional)  Slave node to build Artifact , Docker Images and Application deployment on Kubernates.
        - **Number of Executors**: `2`  
        - **Remote Root Directory**: `/home/ubuntu/jenkins`  
        - **Label**: `slave`  
        - **Usage**: Select `Only build jobs with label expressions matching this node`
        - **Launch Method**: Select `Launch agents via SSH`
            - **Host**: `<jenkins-slave-private-ip>`  
            - **Credentials**: Select `ubuntu` (created in step 1)  
            - **Host Key Verification Strategy**: `Non-verifying Verification Strategy`
        - **Availability**: `Keep this node online as much as possible`
    - Click **Save** to complete the setup.  

### **6. Install Plugins**
- Navigate to **Manage Jenkins → Plugins → Available Plugins**. 
- Search and select the following plugins:  
   - **Artifactory**  
   - **Pipeline: Stage View**  
   - **Docker Pipeline**  
   - **Terraform Plugin**  
- Click **Install** to begin the installation.

## Application Setup  (Under Process can still be optimised...)

### **1. Jenkins Pipeline Configuration**
- Log in to **GitHub**, go to **User Profile → Settings → Developer Settings → Personal Access Tokens → Tokens (Classic)**, click **Generate New Token (Classic)**, enter your password, provide a **Note Name** (e.g., `GitHub Token`), select the **necessary scope permissions** (or select all checkboxes), and click **Generate Token**.
- **Add GitHub Credentials:** 
    - Go to **Manage Jenkins → Manage Credentials**, select **Global**, and click **Add Credentials**.
    - Select **Kind**: **Secret Text** and provide the following details:
        - **Secret**: Copy & Paste generated `GitHub Token`. 
        - **ID**: `git-credentials`  
        - **Description**: Git Personal Access Token.
    - Click **Create**.
- Go to the **Jenkins Dashboard**, click **New Item**, enter the **Item Name** (e.g., `taxi-booking-app`), select **Pipeline** and click **OK**.
- In the **Configure**, select the **General**, provide a **Description** (e.g., `Jenkins pipeline to deploy taxi booking application on K8s using Helm`), enable **Discard Old Builds**, set **Days to Keep Builds** (e.g., `7`), and **Max # of Builds to Keep** (e.g., `5`).
- In the **Pipeline** section, set **Definition** to `Pipeline Script` and inside **Script** select `Hello World` from the dropdown.
- Click **Apply & Save**.

### **2. Creating Pipeline Stages**
1. **Checkout Stage:** 
    - In the **Pipeline** section, click **Pipeline Syntax**, search for **Git**, enter the **Repository URL** (`https://github.com/saishandilya/taxi-booking.git`), select **Branch** as `main`, set **Credentials** to `None`, generate the **Pipeline Script**, copy the generated code, and replace it in the **checkout stage**.  
    - Copy the below code and replace the HelloWorld Code: 
        ```groovy
        pipeline {
            agent { node { label 'slave' } }

            stages {
                stage('Checkout') {
                    steps {
                        echo 'Fetching application code from GitHub'
                        git branch: 'main', url: 'https://github.com/saishandilya/taxi-booking.git'
                        script {
                            env.GIT_COMMIT = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                            echo "Current Git Commit ID: ${env.GIT_COMMIT}"
                        }
                    }
                }
            }
        }
        ```

2. **Compile & Build Stage** 
   - Copy the below provided code and add it as a **new stage** in the Pipeline, this stage compiles the application code and builds the **JAR** or **WAR** file.
   - Add the **Maven** path to the **environment** variables in the Pipeline.
        ```groovy
        environment {
            PATH="/opt/apache-maven-3.9.6/bin:$PATH"
        }
        ```
        #### `Compile & Build Stage`
        ```groovy
        stage('Compile & Build') {
            steps {
                echo 'Compiling and Building the application code using Apache Maven'
                sh 'mvn --version'
                sh 'mvn compile && mvn clean package'
            }
        }
        ```
3. **Generate Test Reports Stage**
    - Copy the below provided code and add it as a **new stage** in the Pipeline, this stage **generates test report** for the **application code using Maven Surefire plugin**.
        #### `Generate Test Report Stage`
        ```groovy
        stage('Generate Test Report') {
            steps {
                echo "Generating test reports for the application code using Maven Surefire plugin"
                sh 'mvn test surefire-report:report'
            }
        }
        ```