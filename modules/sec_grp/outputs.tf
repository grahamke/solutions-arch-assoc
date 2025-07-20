output "sg_id" {
  description = "ID of the security group."
  value       = aws_security_group.sec_grp.id
}