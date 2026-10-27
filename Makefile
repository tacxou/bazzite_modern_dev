# Gestion de la clé de signature cosign (voir README, section "Container signing")
#
#   make cosign-key      génère cosign.key / cosign.pub via Docker
#   make cosign-upload   envoie cosign.key dans le secret GitHub SIGNING_SECRET
#   make cosign          les deux

COSIGN_IMAGE ?= ghcr.io/sigstore/cosign/cosign:latest
SECRET_NAME  ?= SIGNING_SECRET

# Empêche Git Bash de réécrire les chemins passés à docker
export MSYS_NO_PATHCONV := 1

.PHONY: cosign cosign-key cosign-upload

cosign: cosign-key cosign-upload

cosign-key:
ifneq ($(wildcard cosign.key),)
	$(error cosign.key existe déjà, supprime-le d'abord pour en générer une nouvelle)
endif
	docker run --rm -v "$(CURDIR):/work" -w /work -e COSIGN_PASSWORD= $(COSIGN_IMAGE) generate-key-pair

cosign-upload:
ifeq ($(wildcard cosign.key),)
	$(error cosign.key introuvable, lance d'abord: make cosign-key)
endif
	gh secret set $(SECRET_NAME) < cosign.key
