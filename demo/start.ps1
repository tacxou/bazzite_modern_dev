# Démarre la VM sur le disque virtuel déjà installé, sans l'ISO

. (Join-Path $PSScriptRoot "common.ps1")

if (-not (Test-Path $disk)) {
    throw "Disque virtuel introuvable : $disk (lance d'abord install.ps1)"
}

$qemuArgs += @(
    "-boot", "menu=on,order=c"
)

& $qemu @qemuArgs
