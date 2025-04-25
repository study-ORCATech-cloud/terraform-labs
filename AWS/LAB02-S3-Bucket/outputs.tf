# TODO: Define an output for the bucket_id
# Requirements:
# - Name it "bucket_id"
# - Description should be "The name of the bucket"
# - Value should be the ID of the bucket you created
# HINT: Use aws_s3_bucket.lab02_bucket.id

# TODO: Define an output for the bucket_arn
# Requirements:
# - Name it "bucket_arn"
# - Description should be "The ARN of the bucket"
# - Value should be the ARN of the bucket you created
# HINT: Use aws_s3_bucket.lab02_bucket.arn

# TODO: Define an output for the bucket_domain_name
# Requirements:
# - Name it "bucket_domain_name"
# - Description should be "The domain name of the bucket"
# - Value should be the domain name of the bucket you created
# HINT: Use aws_s3_bucket.lab02_bucket.bucket_domain_name

# TODO: Define an output for the bucket_regional_domain_name
# Requirements:
# - Name it "bucket_regional_domain_name"
# - Description should be "The regional domain name of the bucket"
# - Value should be the regional domain name of the bucket you created
# HINT: Use aws_s3_bucket.lab02_bucket.bucket_regional_domain_name

# TODO: Define a conditional output for the website_endpoint
# Requirements:
# - Name it "website_endpoint"
# - Description should indicate this is only available if static website hosting is enabled
# - Value should be the website endpoint if enabled, otherwise null
# - Remember that website_configuration is a conditional resource using count
# HINT: Use var.enable_static_website ? aws_s3_bucket_website_configuration.lab02_website[0].website_endpoint : null

# TODO: Define a conditional output for the website_domain
# Requirements:
# - Name it "website_domain"
# - Description should indicate this is only available if static website hosting is enabled
# - Value should be the website domain if enabled, otherwise null
# HINT: Use var.enable_static_website ? aws_s3_bucket_website_configuration.lab02_website[0].website_domain : null

# TODO: Define a conditional output for the website_url
# Requirements:
# - Name it "website_url"
# - Description should indicate this is only available if static website hosting is enabled
# - Value should be the full URL to access the static website (http://{website_endpoint})
# HINT: Use string interpolation and the website_endpoint from above

# TODO: Define an output for the versioning_status
# Requirements:
# - Name it "versioning_status"
# - Description should be "The versioning status of the bucket"
# - Value should be "Enabled" if versioning is enabled, otherwise "Suspended"
# HINT: Use var.versioning_enabled ? "Enabled" : "Suspended"
