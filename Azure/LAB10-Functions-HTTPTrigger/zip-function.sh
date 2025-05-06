#!/bin/bash
# Simple script to create a zip file from the function-code directory

echo "Creating function.zip from function-code directory..."
cd "$(dirname "$0")"
cd function-code
zip -r ../function.zip .

echo "Done! function.zip created at $(dirname "$0")/function.zip"
echo "You can now proceed with terraform init and terraform apply" 