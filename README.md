# StudyLink
> Plateforme d'entraide étudiante en temps réel — publie une question, reçois de l'aide, continue en message privé jusqu'à la résolution.

---
test push on staging
## Executive Summary

### Problème

Les étudiants manquent d'un espace dédié pour demander de l'aide rapidement sur leurs cours. Les solutions existantes (forums génériques, groupes de chat) sont peu structurées, sans suivi de qualité ni organisation par matière.

### Solution

**StudyLink** est une application web qui centralise l'entraide étudiante en trois fonctionnalités clés :

1. **Un feed social structuré par matière** — les étudiants publient des requêtes d'aide ciblées (avec ou sans snippet de code), les autres commentent et likent.
2. **Une messagerie temps réel** — chaque échange peut basculer vers un chat privé pour aller au bout du problème.
3. **Un système de réputation** — chaque contributeur accumule une note moyenne visible par tous, valorisant les meilleurs contributeurs.

### Stack technique

| Couche | Technologie |
|---|---|
| Backend | Ruby on Rails 8.1 |
| Base de données | SQLite3 |
| Frontend | Tailwind CSS (CDN), Stimulus JS |
| Temps réel | Turbo Streams / Action Cable |
| Authentification | Devise |
| Déploiement | Docker / Kamal |

### Périmètre fonctionnel

- Inscription / connexion avec acceptation obligatoire des CGU
- Feed filtrable par matière avec posts, commentaires, likes et bookmarks
- Messagerie privée temps réel entre utilisateurs
- Page d'exploration des matières disponibles
- Espace "Mes posts" personnel
- Profil utilisateur éditable (bio, niveau, avatar)
- Suppression de compte avec effacement de toutes les données
- Interface d'administration (modération des posts/utilisateurs, gestion des matières)
- Pages légales : CGU, Politique de confidentialité, Mentions légales

---

## User Stories

### Visiteur (non connecté)

| # | En tant que | Je veux | Afin de |
|---|---|---|---|
| 1 | Visiteur | Voir la page d'accueil de présentation | Comprendre ce qu'est StudyLink avant de m'inscrire |
| 2 | Visiteur | Créer un compte avec email et mot de passe | Accéder à la plateforme |
| 3 | Visiteur | Me connecter avec mes identifiants | Retrouver mon compte |
| 4 | Visiteur | Lire les CGU, la politique de confidentialité et les mentions légales | Connaître mes droits et obligations |

### Étudiant connecté — Feed & Posts

| # | En tant que | Je veux | Afin de |
|---|---|---|---|
| 5 | Étudiant | Voir un feed de requêtes d'aide | Trouver des questions auxquelles je peux répondre |
| 6 | Étudiant | Filtrer le feed par matière | Me concentrer sur les sujets que je maîtrise |
| 7 | Étudiant | Publier une requête d'aide avec titre, description et matière | Obtenir de l'aide de la communauté |
| 8 | Étudiant | Ajouter un snippet de code à ma requête | Illustrer mon problème technique |
| 9 | Étudiant | Marquer ma requête comme urgente | Signaler un besoin pressant |
| 10 | Étudiant | Ajouter des tags à ma requête | Aider les autres à trouver ma question |
| 11 | Étudiant | Commenter une requête d'un autre étudiant | Apporter mon aide |
| 12 | Étudiant | Liker un post | Signaler qu'il est pertinent |
| 13 | Étudiant | Sauvegarder un post en bookmark | Le retrouver facilement plus tard |
| 14 | Étudiant | Marquer mon propre post comme résolu | Indiquer que l'aide a été apportée |
| 15 | Étudiant | Supprimer mon propre post | Retirer une question obsolète |
| 16 | Étudiant | Voir la liste de mes propres posts | Suivre mes demandes en cours |

### Étudiant connecté — Messagerie

| # | En tant que | Je veux | Afin de |
|---|---|---|---|
| 17 | Étudiant | Démarrer une conversation privée avec un autre étudiant | Approfondir l'aide en dehors du feed public |
| 18 | Étudiant | Envoyer et recevoir des messages en temps réel | Communiquer sans recharger la page |
| 19 | Étudiant | Voir le nombre de messages non lus | Ne pas rater une réponse importante |
| 20 | Étudiant | Voir si mon interlocuteur est en ligne | Savoir s'il est disponible |

### Étudiant connecté — Profil & Compte

| # | En tant que | Je veux | Afin de |
|---|---|---|---|
| 21 | Étudiant | Modifier mon profil (nom, bio, niveau, avatar) | Personnaliser ma présence sur la plateforme |
| 22 | Étudiant | Voir mes statistiques (aides données, requêtes, note moyenne) | Suivre ma progression |
| 23 | Étudiant | Supprimer définitivement mon compte | Exercer mon droit à l'effacement (RGPD) |
| 24 | Étudiant | Accepter les CGU à la première connexion | Être informé des règles avant d'utiliser l'appli |
| 25 | Étudiant | Demander l'ajout d'une nouvelle matière | Enrichir le catalogue de sujets disponibles |

### Administrateur

| # | En tant que | Je veux | Afin de |
|---|---|---|---|
| 26 | Administrateur | Accéder à un tableau de bord dédié | Gérer la plateforme |
| 27 | Administrateur | Voir et modérer tous les posts | Supprimer les contenus inappropriés |
| 28 | Administrateur | Voir la liste des utilisateurs | Surveiller les inscriptions |
| 29 | Administrateur | Approuver ou refuser les demandes de nouvelles matières | Contrôler le catalogue de sujets |
| 30 | Administrateur | Envoyer des messages à tous les utilisateurs | Communiquer des annonces importantes |
| 31 | Administrateur | Promouvoir un utilisateur au rôle admin | Déléguer la modération |

---

## Schéma de base de données

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│   USERS                          POSTS                                          │
│   ──────────────────             ──────────────────────                         │
│   id              PK             id                PK                           │
│   email                          title                                          │
│   encrypted_password             body                                           │
│   full_name                      code_snippet                                   │
│   headline                       status (open/resolved)                         │
│   bio                            urgent                                         │
│   education_level                education_level                                │
│   avatar_url                     likes_count                                    │
│   rating                         comments_count                                 │
│   role (user/admin)              bookmarks_count                                │
│   cgu_accepted_at                user_id           FK → USERS                   │
│   remember_created_at            subject_id        FK → SUBJECTS                │
│   reset_password_token           created_at                                     │
│   created_at                     updated_at                                     │
│   updated_at                                                                    │
│        │                              │                                         │
│        │ has_many                     │ has_many                                │
│        ├──────────────────────────────▼───────────────────┐                     │
│        │                         COMMENTS                 │                     │
│        │                         ─────────────────        │                     │
│        │                         id            PK         │                     │
│        │                         body                     │                     │
│        │                         user_id   FK → USERS     │                     │
│        │                         post_id   FK → POSTS     │                     │
│        │                         created_at               │                     │
│        │                         updated_at               │                     │
│        │                                                  │                     │
│        │                         LIKES                    │                     │
│        │                         ─────────────────        │                     │
│        │                         id            PK         │                     │
│        │                         user_id   FK → USERS     │                     │
│        │                         post_id   FK → POSTS     │                     │
│        │                         created_at               │                     │
│        │                         updated_at               │                     │
│        │                                                  │                     │
│        │                         BOOKMARKS                │                     │
│        │                         ─────────────────        │                     │
│        │                         id            PK         │                     │
│        │                         user_id   FK → USERS     │                     │
│        │                         post_id   FK → POSTS     │                     │
│        │                         created_at               │                     │
│        └──────────────────────────── updated_at           │                     │
│                                                           │                     │
│   SUBJECTS                       TAGS                     │                     │
│   ──────────────────             ──────────────────       │                     │
│   id          PK                 id          PK           │                     │
│   name                           name                     │                     │
│   slug (unique)                  slug (unique)            │                     │
│   icon                           created_at               │                     │
│   accent_color                   updated_at               │                     │
│   description                                             │                     │
│   posts_count                    POST_TAGS (jointure)     │                     │
│   created_at                     ─────────────────        │                     │
│   updated_at                     id          PK           │                     │
│        │                         post_id FK → POSTS       │                     │
│        └──── has_many POSTS ──── tag_id  FK → TAGS        │                     │
│                                                           │                     │
│   CONVERSATIONS                  SUBJECT_REQUESTS         │                     │
│   ──────────────────             ──────────────────       │                     │
│   id          PK                 id          PK           │                     │
│   direct_key (unique)            name                     │                     │
│   topic                          description              │                     │
│   created_at                     status (pending/…)       │                     │
│   updated_at                     user_id FK → USERS       │                     │
│        │                         created_at               │                     │
│        │ has_many                updated_at               │                     │
│        ▼                                                  │                     │
│   CONVERSATION_PARTICIPANTS      MESSAGES                 │                     │
│   ──────────────────────────     ─────────────────        │                     │
│   id              PK             id            PK         │                     │
│   conversation_id FK             body                     │                     │
│   user_id         FK → USERS     conversation_id FK       │                     │
│   last_read_at                   user_id   FK → USERS     │                     │
│   created_at                     created_at               │                     │
│   updated_at                     updated_at               │                     │
│                                                           │                     │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Relations résumées

| Modèle | Relations |
|---|---|
| **User** | has_many posts, comments, likes, bookmarks, messages, conversation_participants, conversations (through), subject_requests |
| **Post** | belongs_to user, belongs_to subject ; has_many comments, likes, bookmarks, post_tags, tags (through) |
| **Comment** | belongs_to user, belongs_to post |
| **Like** | belongs_to user, belongs_to post *(unicité user+post)* |
| **Bookmark** | belongs_to user, belongs_to post *(unicité user+post)* |
| **Subject** | has_many posts |
| **Tag** | has_many post_tags, has_many posts (through) |
| **PostTag** | belongs_to post, belongs_to tag *(table de jointure)* |
| **Conversation** | has_many conversation_participants, has_many users (through), has_many messages |
| **ConversationParticipant** | belongs_to conversation, belongs_to user |
| **Message** | belongs_to conversation, belongs_to user |
| **SubjectRequest** | belongs_to user |

---

## Installation & lancement

### Prérequis

- Ruby 3.x
- Node.js 18+
- SQLite3

### Démarrage

```bash
# Cloner le projet
git clone <url-du-repo>
cd Projet-Final---All-aboard

# Installer les dépendances
bundle install
npm install

# Créer et migrer la base de données
bin/rails db:create db:migrate db:seed

# Lancer le serveur de développement
bin/dev
```

L'application est accessible à `http://localhost:3000`.

### Variables d'environnement

```bash
# config/credentials.yml.enc — éditer avec :
bin/rails credentials:edit
```

---

## Équipe

Projet réalisé dans le cadre de la formation **The Hacking Project** par Dimitri et Remy.
