variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
  default     = "mybucket"
}

variable "website_port" {
  description = "Port under which the website should be served. (Between localstack ports 4510-4559)"
  type = number
  default = 4550
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}
