 Features of the Project
 1. AWS Provider Configuration
•	The project uses AWS as the cloud provider.
•	The default region is set to us-east-1.
________________________________________
 2. VPC (Virtual Private Cloud)
•	Uses a Terraform module (terraform-aws-modules/vpc/aws) to create a custom VPC.
•	Configured with:
o	Public & Private Subnets
o	NAT Gateway for secure outbound internet access.
o	DNS Hostnames & Support enabled.
________________________________________
 3. S3 Bucket
•	Creates an AWS S3 bucket (my-terraform-bucket-12345) for storage.
•	The bucket is set to private (can be changed to public-read if needed).
________________________________________
 4. Security Group for EC2
•	Allows:
o	SSH (port 22) for remote access.
o	HTTP (port 80) for web traffic.
o	Outbound traffic for unrestricted internet access.
________________________________________
5. EC2 Instance (Web Server)
•	Deploys an Amazon Linux 2 instance with:
o	Public IP for accessibility.
o	Apache Web Server (HTTPD) pre-installed using a user data script.
o	The server automatically starts and serves a basic webpage:
html
CopyEdit
<h1>Deployed via Terraform</h1>
________________________________________
 6. Remote Backend (Optional)
•	Supports S3 backend for storing Terraform state (uncomment the backend block in the code to enable it).
•	Prevents local state corruption and allows team collaboration.

