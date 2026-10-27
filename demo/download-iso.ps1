# Télécharge l'ISO Bazzite dans ce dossier et vérifie son SHA256
# Le téléchargement reprend là où il s'est arrêté s'il est interrompu.

$ErrorActionPreference = "Stop"

$isoName = "bazzite-nvidia-open-stable-live-amd64.iso"
$baseUrl = "https://download.bazzite.gg"
$iso = Join-Path $PSScriptRoot $isoName
$partial = "$iso.part"

$checksumLine = (curl.exe -fsSL "$baseUrl/$isoName-CHECKSUM")
if ($LASTEXITCODE -ne 0) {
    throw "Impossible de récupérer le checksum : $baseUrl/$isoName-CHECKSUM"
}
$expected = ($checksumLine -split "\s+")[0].ToLower()

function Test-IsoHash($path) {
    Write-Host "Vérification du SHA256 de $path..."
    return (Get-FileHash -Algorithm SHA256 $path).Hash.ToLower() -eq $expected
}

if (Test-Path $iso) {
    if (Test-IsoHash $iso) {
        Write-Host "ISO déjà à jour : $iso"
        exit 0
    }
    Write-Host "ISO locale obsolète ou corrompue, nouveau téléchargement."
    Remove-Item $iso
}

curl.exe -fL -C - -o $partial "$baseUrl/$isoName"
if ($LASTEXITCODE -ne 0) {
    throw "Échec du téléchargement (relance le script pour reprendre)."
}

if (-not (Test-IsoHash $partial)) {
    Remove-Item $partial
    throw "SHA256 invalide, fichier supprimé. Relance le script."
}

Move-Item $partial $iso
Write-Host "ISO téléchargée : $iso"
