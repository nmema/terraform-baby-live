# S3 Remote Backend for State Files

1. Initialize the module & provider.
```bash
AWS_PROFILE=prod terraform init
```

2. Comment the [Terraform Backend code](https://github.com/nmema/terraform-baby-live/blob/main/prod/s3_state_backend/main.tf?plain=1#L10-L18) && execute:
```bash
AWS_PROFILE=prod terraform plan && terraform apply
```

3. Uncomment the [Terraform Backend code](https://github.com/nmema/terraform-baby-live/blob/main/prod/s3_state_backend/main.tf?plain=1#L10-L18)  && migrate the stafe file to the remote backend:
```bash
AWS_PROFILE=prod terraform init
```
