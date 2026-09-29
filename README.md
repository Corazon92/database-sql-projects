# Projets SQL & bases de données

> Sélection de projets académiques autour de PostgreSQL, PL/pgSQL et de l'intégration d'une base de données dans une supervision industrielle.  
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

### Intégration supervision

Le projet ne s'arrêtait pas à PostgreSQL : les données étaient exploitées depuis **PcVue**, avec notamment des grilles dynamiques et des composants d'interface pour consulter et manipuler les recettes/productions.

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

### Compétences

**PostgreSQL · SQL · PL/pgSQL · modélisation relationnelle · vues · triggers · fonctions · contraintes · PcVue**

### À propos du code

L'archive du projet contient un script SQL mélangeant travail étudiant et portions de squelette pédagogique fournies pour le TP. Afin de ne pas republier du contenu enseignant comme s'il s'agissait de mon propre code, ce dépôt documente pour l'instant le projet et les éléments réalisés. Une version nettoyée peut être ajoutée en ne conservant que les parties dont l'origine est clairement attribuable.

---

# 🇬🇧 SQL & Database Projects

## Main project — Concrete plant with PostgreSQL + PcVue

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

### Industrial integration

The database was connected to a **PcVue** supervision layer used to display and manipulate production/recipe information.

**Stack:** PostgreSQL · SQL · PL/pgSQL · PcVue · relational modeling · views · triggers · functions

### Source note

The archived SQL file combines student implementation with portions of an instructor-provided lab skeleton. To avoid presenting third-party teaching material as original work, the repository currently focuses on verified project documentation rather than republishing the complete raw file.
