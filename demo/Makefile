# VM de démo Bazzite sous QEMU (Windows)
#
#   make download   télécharge l'ISO Bazzite dans ce dossier
#   make install    démarre la VM sur l'ISO pour installer sur bazzite.qcow2
#   make start      démarre la VM installée, sans l'ISO

PS := powershell -NoProfile -ExecutionPolicy Bypass -File

.PHONY: help download install start

help:
	@echo make download   telecharge l'ISO Bazzite
	@echo make install    installe Bazzite depuis l'ISO
	@echo make start      demarre la VM installee

download:
	$(PS) download-iso.ps1

install:
	$(PS) install.ps1

start:
	$(PS) start.ps1
