variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

variable "algorithm" {
  description = "Algorithm for the key"
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "RSA bits for the key"
  type        = number
  default     = 4096
}

variable "filename" {
  description = "Filename to save the key"
  type        = string
  default     = null
}

variable "file_permission" {
  description = "File permission for the key file"
  type        = string
  default     = "0400"
}

variable "tags" {
  description = "Tags for the key pair"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = null
}