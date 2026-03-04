# ==================================
# CONFIG
# ==================================

$InstancePath = "C:\Users\jacqu\AppData\Roaming\PrismLauncher\instances\forever world - jacques\minecraft"

$BucketName = "minecraft-jacques-s3-paris"
$S3Key = "prism_launcher/instances/forever_world_jacques.zip"

$Profile = "s3_put_minecraft"
$Region = "eu-west-3"

$SevenZip = "C:\Program Files\7-Zip\7z.exe"

# ==================================
# WAIT FOR MINECRAFT TO CLOSE
# ==================================

Write-Host "Surveillance de Minecraft..."

while (Get-Process javaw -ErrorAction SilentlyContinue) {
    Start-Sleep -Seconds 2
}

Write-Host "Minecraft ferme -> Lancement backup..."

# ==================================
# ZIP STREAMING → S3
# ==================================

& "$SevenZip" a -tzip -mx=1 -so "$InstancePath\*" -xr!logs -xr!downloads |
aws s3 cp - "s3://$BucketName/$S3Key" `
    --profile $Profile `
    --region $Region

if ($LASTEXITCODE -eq 0) {

    Write-Host "Upload reussi !!!"
    exit 0
}
else {

    Write-Host "ERREUR upload!"
    exit 1
}
