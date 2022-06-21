# milti-environment-infrastructure-using-terraform
Effective use of Terraform to deploy multi-environment infrastructure

Create a Terraform configuration that deploys 2 VPCs that are simulating preproduction and production environments. The VPCs will be connected via VPC peering. The EC2 instances deployed into the respective VPCs will allow limited ingress and protocols and ports.  The detailed diagram is available in Section 2, Architecture.

Terraform configuration is be modular and should support environment-specific deployment.


<image![deployment diagram](https://user-images.githubusercontent.com/50281621/174695866-a2380fc3-6283-4177-bee4-9318ccc9f956.png)


Diagram explained:
•	VPC nonprod has 2 private and 2 public subnets. Bastion host and NAT gateway are deployed into public subnets in nonprod VPC. VM1 and VM2 are deployed in private subnets of nonprod VPC. Apache webserver is deployed on VM1 and VM2 in nonprod VPC.
•	VPC prod has 2 private subnets and no public subnets. VM1 and VM2 are deployed into private subnets of prod VPC.
•	VPC prod and VPC nonprod are connected via peering connection.
•	Admins can connect to bastion host via SSH using ec2-user. Admins can connect from bastion host to all 4 VMs in prod and nonprod VPCs via SSH using ec2-user. Admins can send HTTP requests to Apache webservers running on VM1 and VM2 in nonprod VPC.
