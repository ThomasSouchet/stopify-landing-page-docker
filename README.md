# landing-page
## Présentation
Le mini site de l'entreprise contient 2 pages :
- la page d'acceuil
- la page de contact

Le site est généré par le framework [hugo](https://gohugo.io/) et le thème utilisé est [bigspring](https://themes.gohugo.io/bigspring-hugo-startup-theme/).
Les sources du site sont présentes dans le dossier nommé `website`.

## Procédures
### Faire tourner le site en local (préproduction)
La génération du site peut être simulée en local grâce à une image docker et à docker-compose.

Un service nommé `dev_server` est défini dans le fichier docker-compose.yml.
- Le stage de build du service crée une image docker dont le `Dockerfile` et les scripts associés se trouvent dans le dossier `docker-image`.
- Lorsque le service est lancé la commande exécutée par le container est `hugo server --bind-"0.0.0.0"` avec un mapping du dossier `website` sur le volume `/src` du container et avec un mapping du port 1313 du container sur le port 1313 de la machine qui fait tourner docker. Cette commande permet de lancer hugo en mode serveur afin de voir en live toutes les modifications apportées au site en ouvrant l'URL http://localhost:1313.

### Comment (re)build l'image de l'environnement de dev
`docker-compose build`

### Comment lancer l'environnement de dev
`docker-compose up` ou `docker-compose up -d` pour passer en mode daemon

### Comment stopper l'environnement de dev
CTRL+C ou `docker-compose down`

### Changer la version d'hugo installée dans l'image Docker
Dans le fichier "docker-image/_script/hugo.sh" et modifier la ligne contenant la variable HUGO_VERSION avec la valeur "0.85.0"
Pour trouver la dernière version d'HuGo:https://github.com/gohugoio/hugo/tags

## Procédure d'Intégration et Déploiement Continu sur GitLab Pages
L'intégration et le déploiement continus sur `GitLab Pages` sont effectués via une pipeline CI/CD.
Le fichier `.gitlab-ci.yml` définis les actions effectuées :
- utilisation d'une image hugo extended dernière version
- définition d'un job nommé `pages` qui :
  - lance la commande `hugo --minify -e gl-pages -s website -d ../website` pour générer les fichiers html en précisant qu'il s'agit de l'environnement hugo `gl-pages`
  - le contenu du dossier public contenant les fichiers html (générés par la commande précédente) est automatiquement déployé sur gitlab pages
  - définition d'un artifact pour le job avec pour path le répertoire `public`
  - affectation de la valeur de la variable `$CI_DEFAULT_BRANCH` (nom de la branche par défaut du projet) à la variable `$CI_COMMIT_BRANCH` (nom de  la branche de commit) uniquement quand le job tourne
- définition d'un job nommé `aws` qui :
  - lance la commande `hugo --minify -e s3 -s website` pour générer les fichiers html en précisant qu'il s'agit de l'environnement hugo `s3`
  - lance la commande `hugo deploy --force --maxDeletes -1 --invalidateCDN -e s3 -s website` pour déployer le site sur AWS
  - affectation de la valeur de la variable `$CI_DEFAULT_BRANCH` (nom de la branche par défaut du projet) à la variable `$CI_COMMIT_BRANCH` (nom de la branche de commit) uniquement quand le job tourne

### Vérification
Pour vérifier l'exécution du pipeline il faut client sur le menu "CI/CD => Pipelines" du dépôt sur gitlab.com.  
Pour accéder au site il faut se rendre sur l'url `http://<votreid>.pages-simplon.akiros.school/stopify-landing-page/`.
