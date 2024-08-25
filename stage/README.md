# Terraform STAGE Environment

1. `cd s3_state_backend` & follow the instructions of the README.

2. 
```bash
cd vpc
AWS_PROFILE=dev terraform init
AWS_PROFILE=dev terraform plan
AWS_PROFILE=dev terraform apply
```

3. 
```bash
cd data-stores/mysql
AWS_PROFILE=dev terraform init
AWS_PROFILE=dev terraform plan
AWS_PROFILE=dev terraform apply
```

4. 
```bash
cd webserver
AWS_PROFILE=dev terraform init
AWS_PROFILE=dev terraform plan
AWS_PROFILE=dev terraform apply
```
