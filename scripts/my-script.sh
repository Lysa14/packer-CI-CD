#!/bin/bash

# Appliquer le patch
patch -p1 < /tmp/my-patch.patch

# Autres commandes nécessaires pour configurer le système après l'application du patch
sudo apt-get update

