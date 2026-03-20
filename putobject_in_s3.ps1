# ==================================
# CONFIG
# ==================================

$InstancePath = "C:\Users\jacqu\AppData\Roaming\PrismLauncher\instances\forever world - jacques\minecraft"

$BucketName = "minecraft-jacques-s3-paris"
$S3Key = "prism_launcher/instances/forever_world_jacques.zip"

$Profile = "s3_put_minecraft"
$Region = "eu-west-3"

$SevenZip = "C:\Program Files\7-Zip\7z.exe"

# taille estimée du backup (important pour multipart)
$ExpectedSize = 3000000000


# ==================================
# STREAM ZIP → S3
# ==================================

$cmd = "`"$SevenZip`" a -tzip -mx=1 -mmt=on -so `"$InstancePath\*`" -xr!logs -xr!downloads | aws s3 cp - s3://$BucketName/$S3Key --expected-size $ExpectedSize --profile $Profile --region $Region"

cmd /c $cmd

# ==================================
# RESULT
# ==================================

if ($LASTEXITCODE -eq 0) {

    Write-Host ""
    Write-Host "Upload reussi vers S3"
    Write-Host "Backup termine"
    exit 0
}
else {

    Write-Host ""
    Write-Host "ERREUR upload S3"
    exit 1
}
