# GCP + TERRAFORM

## Pre-Requisites
1. Terraform client installation: https://www.terraform.io/downloads
2. Cloud Provider account: https://console.cloud.google.com/

## GCP setup
1. Setup for First-time
 - IAM / Access specific to this course
    - Iam & Admin
    - Create Service Accout
        - roles: BigQuery Admin, Compute Admin & Storage Admin
    

## terraform
- Terraform
- vscode extensionn Terraform Hashicorp

1. create `main.tf`
2. enter `terraform fmt` to format the main.tf
3. set `export GOOGLE_CREDENTIALS='</path/filename>.json'`
4. run `terraform init` to set scredentials
5. create bucket on terraform



`terraform plan`  to see a detailed summary of the changes that Terraform plans to make to your infrastructure.

If the plan looks correct, you can apply the changes by running  `terraform apply` 

`terraform destroy`

`.gitignore `to ignore some of sensitive credenstials

### terraform vairables 
- In Terraform, variables are used to parameterize your infrastructure code. They allow you to define values that can be input or configured when you run Terraform commands. Variables make your Terraform configurations more flexible and reusable by allowing you to customize aspects of your infrastructure without modifying the underlying code.




## Resources 
> https://registry.terraform.io/providers/hashicorp/google/latest/docs

