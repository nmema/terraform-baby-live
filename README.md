# Terraform Baby Project
Infrastructure as Code (IaC) Project for learning [Terraform](https://www.terraform.io/).

### Set Up
This project simulates two AWS accounts: `stage` and `prod` environments.

Copy each AWS credentials and paste them under `~/.aws/credentials` in the following format:

```
[dev]
aws_access_key_id=<dev_access_key_id>
aws_secret_access_key=<dev_secret_access_key>
aws_session_token=<dev_session_token>

[prod]
aws_access_key_id=<prod_access_key_id>
aws_secret_access_key=<prod_secret_access_key>
aws_session_token=<prod_session_token>
```
