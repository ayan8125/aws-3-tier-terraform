# Terraform – Highly Available AWS Architecture (ALB + ASG + VPC)

<img width="1536" height="1024" alt="ChatGPT Image Dec 7, 2025, 09_23_41 PM" src="https://github.com/user-attachments/assets/07274dbd-963f-42fc-bc38-743b44c6662d" />


This repository contains Terraform code to provision a complete highly available AWS infrastructure including a VPC, public/private subnets, NAT gateways, Application Load Balancer, Auto Scaling Group, and security groups.

Anyone with valid AWS credentials can clone this repo and launch the full stack automatically.


## 📌 Architecture Overview

### This project sets up:

  - VPC

  - Public & Private Subnets (across 2 AZs)

  - Internet Gateway + NAT Gateways

  - Application Load Balancer

  - Target Group + Health Checks

  - Auto Scaling Group using Launch Template

  - Security Groups

  - Route Tables & Associations

All resources are created using Terraform IaC.

## Module Description

| Module        | Purpose                                           |
| ------------- | ------------------------------------------------- |
| `vpc.tf`      | Creates main VPC                                  |
| `subnets/`    | Public/private subnets, IGW, NAT gateways         |
| `security.tf` | Security groups for ALB and EC2                   |
| `alb.tf`      | Application Load Balancer, listener, target group |
| `asg.tf`      | Auto Scaling Group + Launch Template              |



## Prerequisites

### Install the following tools:

  - Terraform 

  - AWS CLI

  - Git

Verify installation:

```
terraform -version
aws --version
git --version

```

## 🔐 AWS IAM Requirements

Your IAM user should have the following managed policies:

  - AmazonEC2FullAccess
  - AmazonVPCFullAccess

## ⚙️ Setup Instructions

### 1. Configure AWS credentials

```
aws configure
```

Enter:

  - Access Key
  - Secret Key
  - Default Region (ex: us-east-1)
  - Default Output (ex: json)

### 2. Clone this repository

```
git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>
```

### 3. Initialize Terraform

```
terraform init
```

### 4. Validate and plan

```
terraform validate
terraform plan
```

### 5. Deploy resources

```
terraform apply 
```

After a few minutes, Terraform will output the ALB DNS name or once the deployment is complete then follow below steps to get the load balancer dns.

## 🌐 Access Your Application

### Option 1 — Using Terraform Output (Recommended)

After the deployment finishes, Terraform will display the ALB DNS name directly in your terminal:

```
Outputs:
alb_dns = "my-alb-1234567890.us-east-1.elb.amazonaws.com"
```
<img width="1912" height="962" alt="teraforms-outputs" src="https://github.com/user-attachments/assets/39c6377a-d364-4c4f-be1c-e63b6e70d678" />


Simply copy this value and open it in your browser.


Option 2 — Using the AWS Console

If you want to verify manually through AWS:

  1. Sign in to the AWS Management Console
  2. Navigate to EC2 → Load Balancers
  3. Select the Application Load Balancer created by Terraform
  4. In the Description tab, copy the DNS name
  5. Paste the URL into your web browser


## 🖼️ Example Output (Web Page Screenshot)
After you apply the Terraform configuration and copy the ALB DNS, open it in your browser. You should see the application rendering successfully.

<img width="1911" height="1027" alt="terfaorm-output" src="https://github.com/user-attachments/assets/fd128d85-d007-470b-bd16-46d88d8b6a58" />

## 🧽 Cleanup
To remove all AWS resources created by this project:

```
terraform destroy -auto-approve
```

## 🧰 Troubleshooting

### EC2 Instances Not Showing in Target Group

Check in asg.tf that:

```
target_group_arns = [aws_lb_target_group.app_tg.arn]
```

### ALB Shows 502 or Unhealthy

Increase:
```
health_check_grace_period = 300
```

### Security Group Issues

Use TCP, not HTTP:

```
protocol = "tcp"
```


## 💡 Recommended Enhancements

- Add S3 VPC Gateway endpoint (avoid NAT costs)

- Add ACM certificate for HTTPS (443)

- Add CloudWatch alarms for autoscaling policies

- Add Bastion host (optional)

- Add RDS for full 3-tier architecture


🙌 Contributions

Pull requests welcome. Please open an issue for major improvements or new features.
  
