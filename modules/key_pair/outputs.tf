output "key_name" {
  description = "The key pair name."
  value       = aws_key_pair.key_pair.key_name
}

output "key_pair_id" {
  description = "The key pair ID."
  value       = aws_key_pair.key_pair.key_pair_id
}

output "key_id" {
  description = "The key pair name."
  value       = aws_key_pair.key_pair.id
}

output "private_key_pem" {
  description = "Private key data in PEM (RFC 1421) format."
  value       = tls_private_key.private_key.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "The public key data in 'Authorized Keys' format."
  value       = tls_private_key.private_key.public_key_openssh
}

output "identity_filename" {
  description = "The path to the file that will be created."
  value       = local_file.identity_file.filename
}