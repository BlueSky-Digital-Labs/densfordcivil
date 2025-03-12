# State

Terraform state is local by default. However, if you want to use a remote state using S3 which is recommended, ensure that
you have the bucket set up to contain the states. You can manage this using the scripts:

- `list-buckets.sh`
- `create-state-bucket.sh`
- `delete-state-bucket.sh`

Once you have identified the bucket to store your state, add the following block to the `terraform` block:

```hcl
backend "s3" {
  region = "ap-southeast-2"                     # Must be manually set, not via variables. Highly-likely that it needs to match the region the bucket is created in.
  key = "programmed/budget/terraform.tfstate"   # An arbitrary S3 bucket key 
  bucket = "horizon-digital-terraform-states"   # The S3 bucket name
}
```

Then initialise the state remotely using:
```sh
terraform init -backend-config="profile=my-horizon-digital-access-key"
```

where `my-horizon-digital-access-key` is your AWS CLI profile name (check with `aws configure list-profiles`)

or if state has already been initialised, migrate the state using the `-migrate-state` parameter:
```sh
terraform init -migrate-state -backend-config="profile=my-horizon-digital-access-key"
```