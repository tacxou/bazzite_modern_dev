# Configuration partagée par install.ps1 et start.ps1 (dot-sourcé)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$qemuDir = "C:\Program Files\qemu"
$qemu = Join-Path $qemuDir "qemu-system-x86_64.exe"
$qemuImg = Join-Path $qemuDir "qemu-img.exe"
$disk = Join-Path $root "bazzite.qcow2"
$isoName = "bazzite-nvidia-open-stable-live-amd64.iso"
$iso = Join-Path $root $isoName
$vars = Join-Path $root "uefi-vars.fd"

if (-not (Test-Path $qemu)) {
    throw "QEMU introuvable : $qemu"
}

# Recherche des firmwares UEFI
$firmwareDirs = @(
    (Join-Path $qemuDir "share"),
    (Join-Path $qemuDir "share\qemu")
)

$code = $null
$varsTemplate = $null

foreach ($dir in $firmwareDirs) {
    $candidate = Join-Path $dir "edk2-x86_64-code.fd"
    if (Test-Path $candidate) {
        $code = $candidate
        break
    }
}

foreach ($dir in $firmwareDirs) {
    $candidate = Join-Path $dir "edk2-i386-vars.fd"
    if (Test-Path $candidate) {
        $varsTemplate = $candidate
        break
    }
}

if (-not $code -or -not $varsTemplate) {
    throw "Firmware UEFI OVMF introuvable dans QEMU."
}

if (-not (Test-Path $vars)) {
    Copy-Item $varsTemplate $vars
}

$qemuArgs = @(
    "-name", "Bazzite-KDE",
    "-machine", "q35,accel=whpx",
    "-cpu", "max",
    "-smp", "6",
    "-m", "12288",
    "-drive", "if=pflash,format=raw,readonly=on,file=$code",
    "-drive", "if=pflash,format=raw,file=$vars",
    "-drive", "if=none,id=system,format=qcow2,file=$disk",
    "-device", "virtio-blk-pci,drive=system",
    "-device", "virtio-vga",
    "-display", "gtk",
    "-device", "qemu-xhci",
    "-device", "usb-tablet",
    "-audiodev", "dsound,id=snd0",
    "-device", "ich9-intel-hda",
    "-device", "hda-duplex,audiodev=snd0",
    "-nic", "user,model=virtio-net-pci"
)
