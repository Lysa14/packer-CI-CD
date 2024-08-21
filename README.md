# Projet de Création d'OMI avec Packer et GitHub Actions

# Projet Outscale Image Builder

Ce projet utilise [Packer](https://www.packer.io/) pour créer des images machine sur la plateforme Outscale (OMI). L'intégration continue et le déploiement sont gérés par [GitHub Actions](https://github.com/features/actions).

## Prérequis

Avant de commencer, assurez-vous de configurer les secrets GitHub Actions nécessaires pour que le workflow fonctionne correctement.

### Secrets GitHub

Vous devez ajouter les secrets suivants dans les paramètres de votre dépôt GitHub (`Settings` > `Secrets and variables` > `Actions` > `New repository secret`):

- `OUTSCALE_ACCESS_KEY_CUSTOMERname`
- `OUTSCALE_SECRET_KEY_CUSTOMERname`
- `OUTSCALE_REGION`

Remplacez `CUSTOMERname` par le nom du client pour lequel vous souhaitez déployer l'image Outscale.

## Structure des Fichiers

### `packer-scripts/`

Ce répertoire contient les scripts utilisés par Packer pour configurer l'image machine pendant le processus de construction.

- **script.sh** : Script shell personnalisé qui s'exécute pendant le provisionnement de l'image. 
- **setup_boot.service** : Fichier de service systemd qui s'assure que `script.sh` s'exécute au démarrage de la machine virtuelle.



 ### `packer-template.pkr.hcl` 
  Ce fichier est le modèle principal de Packer. Il définit la configuration de l'image à construire.


### `variables.pkr.hcl`

Ce fichier contient les variables utilisées par Packer lors du processus de construction. Ces variables incluent :

- Les clés d'accès Outscale (`OUTSCALE_ACCESS_KEY` et `OUTSCALE_SECRET_KEY`).
- La région Outscale (`OUTSCALE_REGION`).
- L'ID de l'image source (AMI) (`image-id`).
- La version du système d'exploitation (`os_version`).
- Le type de release (`release`).

Ces variables sont injectées dynamiquement via le workflow GitHub Actions pour permettre la personnalisation en fonction du client et des paramètres de build.


## Utilisation de la CI/CD

Le workflow CI/CD de ce projet est déclenché manuellement à l'aide de `workflow_dispatch`. Voici comment l'utiliser :

### Exécution Manuelle avec `workflow_dispatch`

1. **Accédez au Workflow** : Sur la page principale du dépôt GitHub, cliquez sur l'onglet `Actions`.

2. **Sélectionnez le Workflow** : Choisissez le workflow  ( `Build and Publish OMI`).

3. **Renseignez les Paramètres** : Cliquez sur `Run workflow` pour ouvrir le formulaire d'exécution. Vous devrez remplir les champs suivants :
   - `account` : Le nom du client pour lequel l'image sera déployée (par exemple, `CLIENT1`).
   - `image-id` : L'ID de l'image source (AMI) à utiliser pour la construction de l'image.
   - `os_version` : La version du système d'exploitation (par exemple, `Debian`).
   - `release` : Le type de release (par exemple, `Latest`).

4. **Exécutez le Workflow** : Cliquez sur `Run workflow` pour lancer l'exécution. GitHub Actions va alors utiliser Packer pour construire et déployer l'image OMI sur la plateforme Outscale.

### Visualisation des Résultats

Une fois le workflow exécuté, vous pouvez suivre l'état d'avancement de chaque étape dans l'onglet `Actions`.