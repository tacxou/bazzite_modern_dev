# Démarre la VM sur l'ISO pour installer Bazzite sur le disque virtuel
param(
    [string]$DiskSize = "128G"
)

. (Join-Path $PSScriptRoot "common.ps1")

if (-not (Test-Path $iso)) {
    throw "ISO introuvable : $iso (lance d'abord download-iso.ps1)"
}

# Création du disque virtuel s'il n'existe pas encore
if (-not (Test-Path $disk)) {
    & $qemuImg create -f qcow2 $disk $DiskSize
    if ($LASTEXITCODE -ne 0) {
        throw "Échec de la création du disque : $disk"
    }
}

$qemuArgs += @(
    "-drive", "file=$iso,media=cdrom,readonly=on",
    "-boot", "menu=on,order=d"
)

& $qemu @qemuArgs
