# Projet de Création d'OMI avec Packer et GitHub Actions

Ce projet utilise [Packer](https://www.packer.io/) pour créer des images machine sur la plateforme Outscale (OMI).

 L'intégration continue et le déploiement sont gérés par [GitHub Actions](https://github.com/features/actions).

## Prérequis

Avant de commencer, assurez-vous de configurer les secrets github actions.


### Secrets GitHub

Vous devez ajouter les secrets suivants dans les paramètres de votre dépôt GitHub (`Settings` > `Secrets and variables` > `Actions` > `New repository secret`):

- `OUTSCALE_ACCESS_KEY`
- `OUTSCALE_SECRET_KEY`
- `OUTSCALE_REGION`


## Structure des Fichiers

### `packer-scripts/`

Ce répertoire contient les scripts utilisés par Packer pour configurer l'image machine pendant le processus de construction.

- **script.sh** : Script shell personnalisé qui s'exécute pendant le provisionnement de l'image. Il peut contenir des commandes pour installer des logiciels, configurer des services, etc.
- **setup_boot.service** : Fichier de service systemd qui s'assure que `script.sh` s'exécute au démarrage de la machine virtuelle.

- **packer-template.pkr.hcl**: Ce fichier est le modèle principal de Packer.