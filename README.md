# Assignment 2: Terraform Infrastructure Deployment

## Introduction
This repository contains the Terraform code to deploy multi-environment infrastructure as part of Assignment 2. The objective of this project is to demonstrate my skills in applying Terraform to create two VPCs representing preproduction and production environments. The VPCs are connected via peering, and EC2 instances are deployed within each environment.

## Architecture
![deployment diagram](https://user-images.githubusercontent.com/50281621/174695866-a2380fc3-6283-4177-bee4-9318ccc9f956.png)

The architecture consists of the following components:
- VPC nonprod with 2 private and 2 public subnets. Bastion host and NAT gateway are deployed into public subnets, while VM1 and VM2 run Apache webservers in private subnets.
- VPC prod with 2 private subnets. VM1 and VM2 are deployed in private subnets.
- VPC prod and VPC nonprod are connected via VPC peering.
- Admins can connect to the bastion host via SSH and from there, to VMs in both VPCs. Admins can also send HTTP requests to Apache webservers on VM1 and VM2 in the nonprod VPC.

## Prerequisites
Before deploying the infrastructure, ensure you have the following prerequisites in place:
- An AWS account with appropriate permissions to create VPCs, subnets, EC2 instances, security groups, and VPC peering connections.
- Terraform CLI installed on your local machine.
- An S3 bucket to store the Terraform state. Modify the `main.tf` file to set the correct backend configuration for state storage.

## Deployment Steps
1. Clone this repository to your local machine.
2. Set up the Terraform backend configuration in the `main.tf` file to use your S3 bucket for state storage.
3. Initialize Terraform by running `terraform init`.
4. Apply the Terraform configuration to create the infrastructure by running `terraform apply`. Enter 'yes' when prompted to confirm the changes.

## Network Connectivity
- To access the bastion host and connect to VMs in nonprod VPC:
  - Use SSH to connect to the bastion host via the `ec2-user` user.
  - From the bastion host, you can SSH to VM1 and VM2 in nonprod VPC via the `ec2-user` user.
- To access VMs in prod VPC:
  - Connect to the bastion host via SSH as described above.
  - From the bastion host, you can SSH to VM1 and VM2 in prod VPC via the `ec2-user` user.

## Cleanup
After completing the assignment and demonstration, follow these steps to clean up the deployed infrastructure:
1. Run `terraform destroy` to remove all created resources.
2. Confirm the destruction by entering 'yes' when prompted.

## Conclusion
This project demonstrates the effective use of Terraform to deploy multi-environment infrastructure. The modularized and parameterized Terraform configuration allows for repeatable and reliable deployments of VPCs, subnets, and EC2 instances. The use of remote state and correct naming conventions ensures a well-organized and secure infrastructure deployment.
