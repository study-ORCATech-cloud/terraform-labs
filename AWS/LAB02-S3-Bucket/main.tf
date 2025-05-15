# TODO: Create an S3 bucket
# Requirements:
# - Use the bucket_name variable for the bucket name
# - Add tags: Name=var.bucket_name, Environment=var.environment, Lab="LAB02-S3-Bucket"
# HINT: Use the aws_s3_bucket resource


# TODO: Configure bucket versioning
# Requirements:
# - Enable or suspend versioning based on the versioning_enabled variable
# - Use the bucket ID from the bucket you created above
# HINT: Use the aws_s3_bucket_versioning resource


# TODO: Configure bucket ownership
# Requirements:
# - Set object_ownership to "BucketOwnerPreferred"
# - Use the bucket ID from the bucket you created above
# HINT: Use the aws_s3_bucket_ownership_controls resource


# TODO: Configure public access block settings
# Requirements:
# - Block or allow public access based on the allow_public_access variable
# - Remember to negate the variable value since block_public_* expects the opposite
# - Set all four settings: block_public_acls, block_public_policy, 
#   ignore_public_acls, restrict_public_buckets
# HINT: Use the aws_s3_bucket_public_access_block resource


# TODO: Configure bucket ACL
# Requirements:
# - Set ACL to "public-read" if allow_public_access is true, otherwise "private"
# - Make sure this depends on both the ownership controls and public access block settings
# - Use the bucket ID from the bucket you created above
# HINT: Use the aws_s3_bucket_acl resource and depends_on


# TODO: Configure static website hosting (conditional resource)
# Requirements:
# - Only create this resource if enable_static_website is true (use count)
# - Set index_document suffix to "index.html"
# - Set error_document key to "error.html"
# - Use the bucket ID from the bucket you created above
# HINT: Use the aws_s3_bucket_website_configuration resource


# TODO: Add bucket policy for public access (conditional resource)
# Requirements:
# - Only create this policy if both enable_static_website AND allow_public_access are true
# - Create a policy that allows s3:GetObject action for all objects in the bucket
# - Make sure this depends on the public access block settings
# HINT: Use the aws_s3_bucket_policy resource and jsonencode function


# TODO: Upload index.html file for website (conditional resource)
# Requirements:
# - Only upload this file if enable_static_website is true
# - Create an HTML page with:
#   * A title and heading indicating success
#   * Some styling (colors, fonts, etc.)
#   * A list of accomplishments
#   * A timestamp showing when it was created
# - Set the content_type to "text/html"
# HINT: Use the aws_s3_object resource and heredoc syntax


# TODO: Upload error.html file for website (conditional resource)
# Requirements:
# - Only upload this file if enable_static_website is true
# - Create an HTML page styled differently from the index page
# - Include a 404 error message
# - Include a link back to the index page
# - Set the content_type to "text/html"
# HINT: Use the aws_s3_object resource and heredoc syntax
