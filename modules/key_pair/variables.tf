variable "key_name" {
  description = "The name for the key pair."
  type        = string
}

variable "algorithm" {
  description = "Name of the algorithm to use when generating the private key."
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "When algorithm is RSA, the size of the generated RSA key, in bits (default: 4096)."
  type        = number
  default     = 4096
}

variable "filename" {
  description = "The path to the file that will be created."
  type        = string
  default     = null
}

variable "file_permission" {
  description = "Permissions to set for the output file (before umask), expressed as string in numeric notation. Default value if 0400"
  type        = string
  default     = "0400"
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}