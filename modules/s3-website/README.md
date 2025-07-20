# S3 Website Module

This module creates an AWS S3 bucket configured for static website hosting with public access and automatic index file upload.

## Features

- Creates an S3 bucket for static website hosting
- Configures public access permissions for website content
- Sets up bucket policy for public read access
- Enables website configuration with custom index document
- Uploads index file to the bucket automatically

## Usage

```hcl
module "static_website" {
  source = "../modules/s3-website"

  bucket_name         = "my-unique-website-bucket"
  index_file_name     = "index.html"
  index_file_source   = "${path.module}/website/index.html"
}
```

## Inputs

| Name                | Description                              | Type     | Default        | Required |
|---------------------|------------------------------------------|----------|----------------|:--------:|
| `bucket_name`       | Name of the S3 bucket for the website   | `string` | -              |   yes    |
| `index_file_name`   | Name of the index file to serve          | `string` | `"index.html"` |    no    |
| `index_file_source` | Path to local file to use for index     | `string` | `"index.html"` |    no    |

## Outputs

| Name               | Description                        |
|--------------------|------------------------------------|
| `bucket_id`        | ID of the S3 bucket                |
| `website_endpoint` | Website endpoint URL               |

## Security Considerations

- The bucket is configured for public read access to serve website content
- Public access blocks are disabled to allow website hosting
- Only GetObject permissions are granted to anonymous users
- Consider using CloudFront for additional security and performance