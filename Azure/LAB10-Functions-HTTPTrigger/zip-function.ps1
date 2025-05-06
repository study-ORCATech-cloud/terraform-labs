# PowerShell script to create a zip file from the function-code directory

Write-Host "Creating function.zip from function-code directory..."
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path "$scriptPath\function-code"

# Check if Compress-Archive cmdlet is available (PowerShell 5.0+)
if (Get-Command Compress-Archive -ErrorAction SilentlyContinue) {
    Compress-Archive -Path * -DestinationPath ..\function.zip -Force
} else {
    # Fallback for older PowerShell versions
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    if (Test-Path ..\function.zip) {
        Remove-Item ..\function.zip
    }
    [System.IO.Compression.ZipFile]::CreateFromDirectory("$scriptPath\function-code", "$scriptPath\function.zip")
}

Write-Host "Done! function.zip created at $scriptPath\function.zip"
Write-Host "You can now proceed with terraform init and terraform apply" 