# Terraform PROD Environment

1. `cd s3_state_backend` & follow the instructions of the README.

2. 
```bash
cd vpc
AWS_PROFILE=prod terraform init
AWS_PROFILE=prod terraform plan
AWS_PROFILE=prod terraform apply
```

3. 
```bash
cd data-stores/mysql
AWS_PROFILE=prod terraform init
AWS_PROFILE=prod terraform plan
AWS_PROFILE=prod terraform apply
```

4. 
```bash
cd webserver
AWS_PROFILE=prod terraform init
AWS_PROFILE=prod terraform plan
AWS_PROFILE=prod terraform apply
```
