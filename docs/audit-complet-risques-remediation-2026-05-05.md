# Audit complet - points faibles, risques et plan de remediation

Date : 2026-05-05  
Projet : StudyLink  
Portee : backend Rails, securite applicative, temps reel, qualite de code, tests, exploitation

---

## Objectif

Identifier les faiblesses et risques prioritaires de l'application, proposer la meilleure solution pour chaque point, puis fournir un plan complet de correction oriente execution.

---

## Methode d'audit

- Revue de la configuration plateforme (`config/environments`, securite, deploiement, middleware).
- Revue des controleurs et chemins critiques (authentification, autorisation, suppression, actions admin).
- Revue du temps reel (Action Cable + React chat).
- Revue des services IA (moderation, resume, suggestions tags, evenements).
- Revue de la couverture de tests et de la robustesse CI.
- Revue des changements recents et de l'etat local Git.

---

## Synthese executive

L'application est bien avancee et globalement solide sur l'architecture et la CI.  
Le principal risque actuel est la securite applicative sur certaines autorisations (messages/commentaires), suivi par des risques de robustesse (routes de suppression heterogenes, dette de tests d'integration, configuration prod incomplete).

### Priorites immediates
1. Corriger les controles d'acces sur messages et commentaires.
2. Uniformiser les routes/actions de suppression.
3. Renforcer les garde-fous securite production (SSL strict, hosts autorises, CSP).
4. Construire une base de tests d'integration orientee securite.

---

## Matrice des risques

| ID | Risque | Gravite | Probabilite | Impact | Priorite |
|---|---|---|---|---|---|
| R1 | Autorisation insuffisante sur messages | Critique | Elevee | Eleve (lecture/suppression non autorisee) | P0 |
| R2 | Autorisation insuffisante sur suppression commentaires | Critique | Elevee | Eleve (integrite contenu) | P0 |
| R3 | Routes `post :delete` heterogenes | Elevee | Moyenne | Moyen/Eleve (erreurs et regressions) | P0 |
| R4 | Configuration securite prod partielle (`force_ssl`, `hosts`, CSP) | Elevee | Moyenne | Eleve (surface d'attaque) | P1 |
| R5 | Couverture de tests web insuffisante | Elevee | Elevee | Eleve (regressions non detectees) | P1 |
| R6 | `resources` sans index FK | Moyenne | Moyenne | Moyen (perf en charge) | P1 |
| R7 | Dependances front gerees par 2 lockfiles | Moyenne | Elevee | Moyen (build non deterministe) | P1 |
| R8 | Admin setup permanent via cle | Moyenne | Moyenne | Moyen/Eleve (elevation privilege si fuite cle) | P1 |
| R9 | Resilience limitee des jobs/services IA | Moyenne | Moyenne | Moyen (degradations silencieuses) | P2 |
| R10 | Documentation technique partiellement designee | Faible | Elevee | Moyen (onboarding/erreurs humaines) | P2 |

---

## Detail des points faibles et meilleure solution

### R1 - Autorisation insuffisante sur messages (Critique)

#### Constat
- Le chargement de message est fait via un `Message.find(params[:id])` global dans `app/controllers/messages_controller.rb`.
- La verification d'auteur n'est pas appliquee a toutes les actions sensibles.

#### Risque
- Acces potentiel a des messages hors conversation de l'utilisateur.
- Suppression potentielle d'un message non possede.

#### Meilleure solution
- Appliquer une autorisation par ressource et par action :
  - Charger le message depuis le perimetre de l'utilisateur (conversation a laquelle il participe).
  - Exiger l'auteur pour `destroy`/`delete`, conserver lecture si participant.
- Option recommandee long terme : centraliser les regles via Pundit/ActionPolicy.

#### Critere d'acceptation
- Un utilisateur A ne peut ni lire ni supprimer un message de B hors conversation.
- Un utilisateur participant non auteur ne peut pas supprimer le message.

---

### R2 - Autorisation insuffisante sur suppression commentaires (Critique)

#### Constat
- `CommentsController` protege `edit/update`, pas `destroy`.

#### Risque
- Suppression de commentaires d'autres utilisateurs.

#### Meilleure solution
- Proteger `destroy` par la meme regle d'auteur (ou admin explicite si voulu).
- Ajouter un test d'acces interdit.

#### Critere d'acceptation
- `destroy` retourne refus d'acces si l'utilisateur n'est pas proprietaire du commentaire.

---

### R3 - Routes de suppression heterogenes (Elevee)

#### Constat
- Melange de routes REST classiques (`DELETE`) et routes custom `POST /.../delete`.
- Certains controleurs aliasent `delete`, d'autres non.

#### Risque
- Incoherences fonctionnelles, maintenance plus couteuse, risque de regression.

#### Meilleure solution
- Standardiser sur REST :
  - `resources ... only: [:destroy]` + `method: :delete`.
- Si contrainte Turbo/UI : conserver un seul pattern coherent partout.

#### Critere d'acceptation
- Tous les endpoints de suppression suivent la meme convention.
- Plus de dependance aux alias `delete` cote controleurs.

---

### R4 - Securite production partielle (Elevee)

#### Constat
- `config.assume_ssl = true` actif, mais `force_ssl` commente en prod.
- `config.hosts` et `host_authorization` non configures.
- CSP desactivee (`config/initializers/content_security_policy.rb` commente).

#### Risque
- Surface accrue face a attaques de transport/hotes/injection script.

#### Meilleure solution
- Activer `force_ssl` en production (avec exclusion healthcheck si necessaire).
- Definir explicitement les hosts autorises.
- Activer une CSP stricte progressive :
  1) mode report-only,
  2) correction des violations,
  3) mode enforce.

#### Critere d'acceptation
- Requetes HTTP redirigees HTTPS.
- Seuls les hotes autorises repondent.
- Header CSP present et violations monitorees.

---

### R5 - Couverture de tests web insuffisante (Elevee)

#### Constat
- Peu de tests controllers/integration/system malgre une application riche.

#### Risque
- Regressions invisibles en authz, flows Turbo/React, moderation, messaging.

#### Meilleure solution
- Introduire une pyramide minimale :
  - Integration tests pour auth/authz (cas interdits).
  - Controller tests pour endpoints sensibles.
  - 3 a 5 system tests critiques (publication, commentaire, message, suppression).

#### Critere d'acceptation
- Les flux critiques disposent d'au moins un test positif et un test de refus.

---

### R6 - Absence d'index sur `resources.subject_id` et `resources.user_id` (Moyenne)

#### Constat
- FK presentes dans `db/schema.rb`, mais indexes manquants sur ces colonnes.

#### Risque
- Degradation de performance avec la volumetrie (recherche, jointures, listes).

#### Meilleure solution
- Ajouter migrations d'index ciblees sur colonnes de jointure/filtre.

#### Critere d'acceptation
- Requetes `resources` filtrees par sujet/utilisateur utilisent les index.

---

### R7 - Gestion npm + yarn simultanee (Moyenne)

#### Constat
- `package-lock.json` et `yarn.lock` actifs, avec ecarts de resolution possibles.

#### Risque
- Build non deterministe selon machine/CI.

#### Meilleure solution
- Choisir un seul gestionnaire (recommande npm ici vu lockfile vivant), supprimer l'autre lockfile et aligner la CI.

#### Critere d'acceptation
- Installation identique local/CI avec un seul lockfile source de verite.

---

### R8 - Endpoint admin setup expose en continu (Moyenne)

#### Constat
- `AdminSetupController` fonctionne tant que cle valide, sans verrou applicatif une fois un admin cree.

#### Risque
- Si fuite de cle, creation d'admin non legitime.

#### Meilleure solution
- Couper le bootstrap admin apres initialisation :
  - Autoriser uniquement si aucun admin n'existe.
  - Et/ou feature flag d'activation ponctuelle.
  - Journaliser toute tentative.

#### Critere d'acceptation
- Creation admin initiale impossible apres bootstrap (sauf procedure explicitement activee).

---

### R9 - Resilience limitee jobs/services IA (Moyenne)

#### Constat
- Gestion erreurs presente mais peu de retry/monitoring metier.
- `update_column` utilise dans certains jobs et controleurs admin.

#### Risque
- Echecs silencieux, tracabilite faible, effets de bord non valides.

#### Meilleure solution
- Definir une strategie de retry ciblee (timeouts API, deadlocks).
- Instrumenter (logs structures, metriques d'erreur).
- Reserver `update_column` aux cas justifies documentes.

#### Critere d'acceptation
- Taux d'echec observable et retries maitrises.

---

### R10 - Documentation technique partiellement designee (Faible)

#### Constat
- README incomplet sur l'evolution React/Monaco et conventions de routes/actions.

#### Risque
- Mauvaises decisions techniques, onboarding plus lent.

#### Meilleure solution
- Mettre a jour README + ajouter une section "conventions architecture et endpoints".

#### Critere d'acceptation
- Un nouveau dev peut lancer et comprendre les patterns majeurs en moins de 30 min.

---

## Plan complet de remediation

### Phase 0 - Securisation urgente (J0-J2)

#### Objectif
Supprimer les vulnerabilites d'autorisation et stabiliser la suppression.

#### Actions
1. Corriger authz `MessagesController` (lecture/suppression).
2. Corriger authz `CommentsController#destroy`.
3. Uniformiser routes/actions de suppression.
4. Ajouter tests d'integration de non-regression securite.

#### Livrables
- PR "Security hotfix authz".
- Tests rouges/verts documentes.

#### KPI
- 0 bypass authz reproduisible sur messages/commentaires.
- 100% des endpoints de suppression alignes.

---

### Phase 1 - Durcissement plateforme (Semaine 1)

#### Objectif
Reduire la surface d'attaque et fiabiliser l'execution.

#### Actions
1. Activer `force_ssl` et configurer `config.hosts`.
2. Deployer CSP en report-only puis enforce.
3. Ajouter index DB manquants sur `resources`.
4. Decider et appliquer une strategie unique npm/yarn.
5. Restreindre `admin-setup` post-bootstrap.

#### Livrables
- PR "Platform hardening".
- Checklist securite prod validee.

#### KPI
- Headers securite presents en prod.
- Requetes resources optimisees sur colonnes indexees.

---

### Phase 2 - Qualite et observabilite (Semaine 2)

#### Objectif
Prevenir les regressions et ameliorer la maintenabilite.

#### Actions
1. Creer un lot de tests system sur parcours critiques.
2. Ajouter instrumentation des services/jobs IA (succes, erreur, latence).
3. Standardiser la politique `update_column`.
4. Mettre a jour la documentation technique.

#### Livrables
- PR "Quality and observability".
- Guide de conventions techniques.

#### KPI
- Couverture des parcours critiques augmentee.
- Visibilite claire sur la sante des jobs IA.

---

## Plan de deploiement recommande

1. Deployer Phase 0 en premier (hotfix).
2. Executer un run de tests complet + smoke test manuel sur suppression/messaging.
3. Deployer Phase 1 en fenetre controlee (verification reverse proxy + SSL).
4. Activer CSP enforce seulement apres 48h de report-only sans alerte bloquante.
5. Deployer Phase 2 avec revue de dette technique mensuelle.

---

## Backlog de tickets (pret a creer)

- SEC-001 : Scope user sur `MessagesController#set_message`.
- SEC-002 : Protection `CommentsController#destroy`.
- API-001 : Unification routes de suppression.
- OPS-001 : `force_ssl` + `config.hosts`.
- OPS-002 : CSP report-only puis enforce.
- DB-001 : Index `resources(user_id)` et `resources(subject_id)`.
- DX-001 : Standard npm/yarn unique.
- SEC-003 : Verrouillage `admin-setup` apres bootstrap.
- QA-001 : Tests integration authz.
- QA-002 : Tests system flux critiques.
- OBS-001 : Instrumentation jobs/services IA.
- DOC-001 : Mise a jour README/conventions.

---

## Conclusion

La meilleure strategie est de traiter d'abord la securite d'autorisation (P0), puis le durcissement plateforme (P1), puis la qualite/observabilite (P2).  
Avec ce plan, StudyLink passe d'un bon MVP avance a une base beaucoup plus robuste, securisee et industrialisable.
