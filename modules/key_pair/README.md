# Key Pair Module

This module creates an AWS key pair for SSH access to EC2 instances and saves the private key locally.

## Features

- Generates a new TLS private key
- Creates an AWS key pair using the public key
- Saves the private key to a local file with secure permissions

## Usage

```hcl
module "ec2_key_pair" {
  source = "../modules/key_pair"

  key_name = "my-instance-key"
  filename = "${path.module}/my-instance-key.pem"
  tags = {
    Name = "My EC2 Key Pair"
  }
}
```

## Inputs

| Name              | Description                      | Type          | Default  | Required |
|-------------------|----------------------------------|---------------|----------|:--------:|
| `key_name`        | Name of the key pair             | `string`      | -        |   yes    |
| `algorithm`       | Algorithm for the key            | `string`      | `"RSA"`  |    no    |
| `rsa_bits`        | RSA bits for the key             | `number`      | `4096`   |    no    |
| `filename`        | Filename to save the key         | `string`      | `null`   |    no    |
| `file_permission` | File permission for the key file | `string`      | `"0400"` |    no    |
| `tags`            | Tags for the key pair            | `map(string)` | `{}`     |    no    |
| `region`          | Region where resource is managed | `string`      | `null`   |    no    |

## Outputs

| Name                 | Description                           |
|----------------------|---------------------------------------|
| `key_name`           | The key pair name                     |
| `key_pair_id`        | ID of the key pair                    |
| `key_id`             | The key pair name                     |
| `private_key_pem`    | Private key in PEM format (sensitive) |
| `public_key_openssh` | Public key in OpenSSH format          |
| `identity_filename`  | Path to the saved private key file    |

## Security Considerations

- The private key is stored locally with 0400 permissions (read-only by owner)
- The private key output is marked as sensitive to prevent accidental exposure