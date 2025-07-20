variable "ssh_cidr_block" {
  type        = string
  description = "The source IPv4 CIDR range for SSH access."
  default     = "0.0.0.0/0"
}