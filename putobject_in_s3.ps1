# ==================================
# CONFIG
# ==================================

$InstancePath = "C:\Users\jacqu\AppData\Roaming\PrismLauncher\instances\forever world - jacques\minecraft"

$BucketName = "minecraft-jacques-s3-paris"
$S3Prefix = "prism_launcher/instances"
$S3Key = "forever_world_jacques.zip"
$Profile = "s3_put_minecraft"

$TempFolder = "$env:TEMP\mc_instance_temp"
$ZipFile = "$env:TEMP\forever_world_jacques.zip"

# ==================================
# WAIT FOR MINECRAFT TO CLOSE
# ==================================

Write-Host "Surveillance de Minecraft..."

while (Get-Process javaw -ErrorAction SilentlyContinue) {
    Start-Sleep -Seconds 5
}

Write-Host "Minecraft fermé -> Lancement backup..."

# ==================================
# COPY WITH EXCLUSIONS
# ==================================

if (Test-Path $TempFolder) {
    Remove-Item $TempFolder -Recurse -Force
}

New-Item -ItemType Directory -Path $TempFolder | Out-Null

# Robocopy exclusions
robocopy $InstancePath $TempFolder `
    /E `
    /XD logs downloads `
    /NFL /NDL /NJH /NJS /nc /ns /np

# ==================================
# 7-ZIP
# ==================================

& "C:\Program Files\7-Zip\7z.exe" a -tzip $ZipFile "$TempFolder\*"

# ==================================
# UPLOAD
# ==================================

aws s3 cp $ZipFile s3://$BucketName/$S3Prefix/$S3Key --profile $Profile --region eu-west-3

if ($LASTEXITCODE -eq 0) {

    Write-Host "Upload reussi !!!"
    
    Remove-Item $TempFolder -Recurse -Force
    Remove-Item $ZipFile -Force

    Write-Host "Le script a fait son boulot!."
    exit 0
}
else {
    Write-Host "ERREUR upload!"
    exit 1
}
