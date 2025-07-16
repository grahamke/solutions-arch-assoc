variable "bucket_name" {
  type        = string
  description = "The name of the bucket to host the static website"
}

variable "index_file_name" {
  type        = string
  description = "The name of the index file to serve"
  default     = "index.html"
}

variable "index_file_source" {
  type        = string
  description = "The name of the local file to use for index.html"
  default     = "index.html"
}