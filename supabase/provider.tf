provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "us-east-1"

  # only required for non virtual hosted-style endpoint use case.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#s3_force_path_style
  s3_use_path_style           = false
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    # use endpoint of localstack
    ec2           = "http://localhost:4566"
    iam           = "http://localhost:4566"
    s3            = "http://localhost:4566"
    glacier       = "http://localhost:4566"
    sns           = "http://localhost:4566"
    organizations = "http://localhost:4566"
  }
}
