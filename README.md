# Projets SQL & bases de données

> Projet académique : refonte d'une base PostgreSQL de centrale à béton et intégration avec une supervision PcVue.
> **English version below.**

## 🇫🇷 Projet principal — Centrale à béton PostgreSQL + PcVue

### Objectif

Modéliser la partie données d'une centrale à béton et l'exploiter depuis une supervision **PcVue**. La base gère les recettes, les clients et les productions, avec des règles d'intégrité directement portées par PostgreSQL.

### Modèle de données

Trois entités principales :
- **recette** : nom et proportions granulat/eau/adjuvant/ciment ;
- **client** : informations du client ;
- **production** : recette utilisée, client, quantité, horodatage et référence.

Les relations sont protégées par des clés étrangères et des contraintes métier.

### Travail SQL / PL/pgSQL

Le projet met en œuvre :
- création du schéma et des tables ;
- clés primaires et étrangères ;
- contraintes `NOT NULL`, `UNIQUE` et `CHECK` ;
- vues dédiées aux clients, recettes et productions ;
- jointures entre productions, clients et recettes ;
- fonctions **PL/pgSQL** ;
- triggers `BEFORE INSERT`, `BEFORE UPDATE` et `INSTEAD OF INSERT` sur vue ;
- génération automatique d'une référence de production ;
- validation de la somme des proportions d'une recette ;
- insertion d'une production à travers une vue.

Une édition publiable et exécutable des sources se trouve dans [`sql/`](sql/).
Elle utilise des noms cohérents en anglais et uniquement des données de
démonstration fictives. Les scripts s'exécutent dans l'ordre numérique.

### Intégration supervision

Le projet ne s'arrêtait pas à PostgreSQL. Dans **PcVue**, les scripts utilisent `Sql_Command` pour ouvrir/fermer la connexion, exécuter les requêtes et lire les buffers de résultat.

Les grilles clients et productions sont construites dynamiquement à partir du nombre de lignes/champs et des noms de colonnes retournés par PostgreSQL (`BUFFERLINECOUNT`, `BUFFERFIELDCOUNT`, `BUFFERFIELDNAME`). Une ComboBox client est également rafraîchie depuis les données récupérées.

Le bouton **Lancer Prod** construit une insertion, l'exécute de manière événementielle puis envoie la recette vers l'automate. Les essais du rapport vérifient que la production apparaît à la fois dans PcVue et dans PostgreSQL.

La communication a aussi été observée avec **Wireshark** : handshake TCP en trois étapes et vérification des requêtes/réponses entre la supervision et la base.

Cette partie a permis de travailler sur le chemin complet :

```text
Utilisateur / supervision PcVue
            │
            ▼
     requêtes / événements
            │
            ▼
        PostgreSQL
   vues · fonctions · triggers
            │
            ▼
 recettes · clients · productions
```

## Provenance et nettoyage

Le fichier de travail archivé mélangeait les ajouts du binôme, des fonctions
fournies pour le cours, des marqueurs `À COMPLÉTER` et des coordonnées réelles.
Il reste conservé sans modification dans l'archive privée, mais n'est pas publié
tel quel. Les fichiers de [`sql/`](sql/) constituent une réécriture propre du
comportement vérifié : schéma, contraintes, vues et triggers.

L'export PcVue complet contient aussi une configuration de poste et des
éléments fournis avec l'environnement pédagogique ; il n'est donc pas ajouté
brut au dépôt.

### Compétences

**PostgreSQL · SQL · PL/pgSQL · modélisation relationnelle · vues · triggers · fonctions · contraintes · PcVue**

### Point d'architecture

Le modèle initial référençait clients et recettes sous forme trop peu contrainte. Le travail de refonte introduit des clés étrangères et expose à l'application des **vues dédiées** plutôt qu'un accès direct inutile aux tables. Des triggers portent ensuite certaines règles métier côté base.

### À propos du code

L'archive du projet contient un script SQL mélangeant travail étudiant et portions de squelette pédagogique fournies pour le TP. Le fichier brut n'est pas republié. Une **édition de publication réécrite et nettoyée** est disponible dans [`sql/`](sql/) avec des exemples entièrement fictifs.

---

# 🇬🇧 SQL & Database Project

## Concrete plant with PostgreSQL + PcVue

### Goal

Model the data layer of a concrete production plant and connect it to an industrial **PcVue** supervision interface.

The PostgreSQL database manages recipes, customers and production records while enforcing business rules at database level.

### Database work

The project includes:
- relational schema design;
- primary and foreign keys;
- `NOT NULL`, `UNIQUE` and `CHECK` constraints;
- customer, recipe and production views;
- joins across production data;
- **PL/pgSQL** functions;
- database triggers;
- automatic production-reference generation;
- recipe-composition validation;
- inserts performed through a view.

The runnable publication edition is available in [`sql/`](sql/). Run the files
in numerical order; the final demo-data script is optional.

### Industrial integration

The database was connected to **PcVue** through event-driven scripts using `Sql_Command`. Client and production grids are dynamically sized from query metadata, and production requests can be inserted from the supervision interface. Network exchanges were also inspected with Wireshark.

**Stack:** PostgreSQL · SQL · PL/pgSQL · PcVue · relational modeling · views · triggers · functions

### Source note

The archived SQL file combines student implementation, an instructor-provided
lab skeleton, unfinished placeholders and real contact data. The raw file remains
unchanged in the private archive. The public `sql/` directory is a clean rewrite
of the verified schema, views and trigger behaviour using synthetic examples.
