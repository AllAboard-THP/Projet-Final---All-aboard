# Audit securite complet - StudyLink

Date : 2026-05-05  
Portee : Application Rails (web, API JSON, Action Cable, jobs, configuration production)  
Objectif : Identifier les risques de securite, proposer les meilleures corrections et fournir un plan complet de remediation.

---

## 1) Resume executif

L'application a de bonnes bases securite (auth Devise, throttling Rack::Attack, CI securite avec Brakeman et bundler-audit), mais expose encore plusieurs risques importants :

- **Critique** : controles d'autorisation incomplets sur messages/commentaires.
- **Eleve** : hardening production incomplet (`force_ssl`, `hosts`, CSP non active).
- **Eleve** : surface d'actions destructives heterogene via routes custom `post :delete`.
- **Moyen** : endpoint de bootstrap admin durablement accessible par cle.
- **Moyen** : couverture de tests securite insuffisante pour prevenir les regressions.

La priorite est de corriger les autorisations (P0), puis de durcir la config production (P1), puis de consolider gouvernance/tests/observabilite (P2).

---

## 2) Constat technique (factuel)

### Points positifs

- Authentification centralisee avec Devise et sessions Rails.
- Rate limiting actif via `Rack::Attack` sur login, signup, posts, commentaires, messages, suggestions IA.
- CI incluant scans securite (`brakeman`, `bundler-audit`).
- Validation de formats (email, mot de passe), controles upload avatar (type + taille).
- Action Cable verifie l'acces a la conversation avant abonnement.

### Points de vigilance observes

- `MessagesController#set_message` charge `Message.find(params[:id])` sans scope utilisateur.
- `MessagesController#destroy` n'impose pas la regle auteur.
- `CommentsController#destroy` n'est pas couvert par `authorize_author!`.
- `production.rb` : `assume_ssl` actif mais `force_ssl` commente.
- `production.rb` : `config.hosts` / `host_authorization` non configures.
- CSP globale non active (`content_security_policy.rb` entierement commente).
- `admin-setup` accessible via cle statique, sans verrou post-bootstrap.
- Multiples routes de suppression en `post :delete` (convention non uniforme).

---

## 3) Matrice de risques securite

| ID | Risque | Gravite | Probabilite | Impact | Priorite |
|---|---|---|---|---|---|
| SEC-01 | IDOR / authorization bypass sur messages | Critique | Elevee | Tres eleve | P0 |
| SEC-02 | Suppression non autorisee de commentaires | Critique | Elevee | Tres eleve | P0 |
| SEC-03 | Hardening HTTPS incomplet en production | Elevee | Moyenne | Eleve | P1 |
| SEC-04 | CSP desactivee | Elevee | Moyenne | Eleve | P1 |
| SEC-05 | Hosts non restreints | Elevee | Moyenne | Eleve | P1 |
| SEC-06 | Endpoint admin bootstrap persistant | Moyenne | Moyenne | Eleve | P1 |
| SEC-07 | Endpoints destructifs heterogenes | Moyenne | Elevee | Moyen | P1 |
| SEC-08 | Faible couverture tests securite | Moyenne | Elevee | Eleve | P1 |
| SEC-09 | Observabilite securite limitee | Moyenne | Moyenne | Moyen | P2 |
| SEC-10 | Gouvernance des secrets/processus a formaliser | Moyen/Faible | Moyenne | Moyen | P2 |

---

## 4) Faiblesses detaillees et meilleure solution

### SEC-01 - Autorisation messages (critique)

#### Probleme
Le chargement d'un message par ID global permet d'atteindre des ressources hors perimetre conversation utilisateur.

#### Risque
Lecture/suppression de messages d'autres utilisateurs (IDOR/BOLA).

#### Meilleure solution
- Charger le message via scope de conversation de l'utilisateur :
  - `current_user.conversations.joins(:messages)...`
  - ou `@conversation.messages.find(...)` apres verification de participant.
- Appliquer des policies explicites par action (Pundit/ActionPolicy recommande).
- Exiger l'auteur pour `destroy` (ou role admin explicite documente).

#### Critere d'acceptation
- Un utilisateur non participant recoit `403/404`.
- Un participant non auteur ne peut pas supprimer.

---

### SEC-02 - Autorisation commentaires (critique)

#### Probleme
`destroy` n'est pas protege comme `edit/update`.

#### Risque
Suppression de contenu tiers.

#### Meilleure solution
- Etendre `authorize_author!` a `destroy`.
- Eventuellement autoriser admin via policy claire.

#### Critere d'acceptation
- `destroy` refuse si user non proprietaire (hors admin policy).

---

### SEC-03 - HTTPS strict incomplet (eleve)

#### Probleme
`assume_ssl` est actif, mais `force_ssl` reste commente.

#### Risque
Navigation non forcee HTTPS selon topologie reverse proxy.

#### Meilleure solution
- Activer `config.force_ssl = true`.
- Configurer exception healthcheck si necessaire.
- Verifier cookies secure + HSTS effectif.

#### Critere d'acceptation
- Toute requete HTTP est redirigee HTTPS.

---

### SEC-04 - CSP non active (eleve)

#### Probleme
Aucune politique CSP appliquee.

#### Risque
Impact augmente en cas d'injection script/XSS.

#### Meilleure solution
- Activer CSP en 3 etapes :
  1) report-only,
  2) correction des violations,
  3) enforcement.
- Utiliser nonce pour scripts/styles inline necessaires.

#### Critere d'acceptation
- Headers CSP presents en prod, violations tracees, puis enforcement.

---

### SEC-05 - Host header hardening absent (eleve)

#### Probleme
`config.hosts` non renseigne.

#### Risque
Surface potentielle d'abus Host header / DNS rebinding.

#### Meilleure solution
- Declarer explicitement domaines autorises.
- Definir exclusion ciblee pour `/up` si besoin.

#### Critere d'acceptation
- Requetes hors hosts autorises rejetees.

---

### SEC-06 - Bootstrap admin durable (moyen)

#### Probleme
`admin-setup` repose sur une cle reutilisable stockee en session.

#### Risque
Si cle compromise, creation admin non legitime.

#### Meilleure solution
- Autoriser setup seulement si aucun admin n'existe.
- Desactiver route en runtime via feature flag apres bootstrap.
- Journaliser et alerter toute tentative d'acces.

#### Critere d'acceptation
- Endpoint inoperant une fois le premier admin cree (hors procedure explicite).

---

### SEC-07 - Actions destructives heterogenes (moyen)

#### Probleme
Mix de `DELETE` REST et `POST /delete`.

#### Risque
Maintenance fragile, oublis d'authz, comportements incoherents.

#### Meilleure solution
- Standardiser les suppressions en `DELETE` REST.
- Conserver une convention unique sur toutes les ressources.

#### Critere d'acceptation
- Suppressions uniformes + controles d'acces centralises.

---

### SEC-08 - Tests securite insuffisants (moyen/eleve)

#### Probleme
Peu de tests integration/controller sur authz negative paths.

#### Risque
Reintroduction de failles apres refactor.

#### Meilleure solution
- Ajouter tests "deny by default" sur:
  - messages show/update/destroy,
  - comments destroy,
  - routes admin non autorisees.
- Ajouter tests system ciblant flux critiques.

#### Critere d'acceptation
- Chaque controle sensible a au moins 1 test autorise + 1 test refuse.

---

### SEC-09 - Observabilite securite limitee (moyen)

#### Probleme
Peu de metriques securite (403, throttling, tentatives admin setup).

#### Risque
Detection tardive d'abus.

#### Meilleure solution
- Instrumenter:
  - compteurs 401/403/429,
  - evenements admin setup,
  - violations CSP.
- Dashboard minimal securite + alertes seuil.

#### Critere d'acceptation
- Vue operationnelle des signaux securite en production.

---

### SEC-10 - Secrets et runbook (moyen/faible)

#### Probleme
Processus de rotation/revocation et procedures incidentes peu formalises.

#### Risque
Reaction lente en cas de fuite cle/token.

#### Meilleure solution
- Ecrire runbook:
  - rotation creds (SMTP/API/admin key),
  - revocation sessions,
  - checklist post-incident.
- Mettre une cadence de rotation.

#### Critere d'acceptation
- Procedure de reponse securite testee une fois/trimestre.

---

## 5) Plan complet d'amelioration

### Phase P0 - Correctifs critiques (J0 a J2)

Objectif : fermer les failles d'autorisation exploitables.

Actions :
1. Corriger scope et authorisation dans `MessagesController`.
2. Proteger `CommentsController#destroy`.
3. Uniformiser provisoirement les checks d'acces sur actions destructives.
4. Ajouter tests d'integration negatifs correspondants.

Livrables :
- PR "security-hotfix-authz".
- Rapport de tests avant/apres.

Gate de sortie :
- Aucune operation non autorisee possible sur messages/commentaires via tests.

---

### Phase P1 - Hardening production (Semaine 1)

Objectif : reduire la surface d'attaque globale.

Actions :
1. Activer `force_ssl` et verifier HSTS/cookies.
2. Configurer `config.hosts` + host authorization.
3. Deployer CSP en report-only puis enforce.
4. Restreindre `admin-setup` post-bootstrap.
5. Rationaliser les routes destructives (`DELETE`).

Livrables :
- PR "platform-hardening-security".
- Checklist securite production validee.

Gate de sortie :
- Headers securite conformes et trafic HTTP force vers HTTPS.

---

### Phase P2 - Industrialisation securite (Semaine 2)

Objectif : installer une securite durable dans le cycle de dev.

Actions :
1. Etendre la couverture tests securite (integration + system).
2. Ajouter observabilite securite (401/403/429/CSP).
3. Formaliser runbook incident + rotation secrets.
4. Evaluer adoption policy framework (Pundit/ActionPolicy) pour uniformiser les regles.

Livrables :
- PR "security-governance-observability".
- Runbook securite versionne.

Gate de sortie :
- Processus securite reproductible + detectabilite des anomalies.

---

## 6) Plan de verification (definition of done)

### Verifications techniques
- Tests integration securite passent.
- Aucun endpoint sensible sans controle explicite.
- En prod, `force_ssl`, hosts et CSP actifs.
- Logs securite exploitables (403/429/admin setup).

### Verifications fonctionnelles
- Un user standard ne peut ni lire ni supprimer des ressources hors perimetre.
- Un non-admin ne peut atteindre aucune action admin.
- Les workflows legitimes restent fonctionnels (chat, commentaires, moderation).

---

## 7) Backlog de tickets securite (pret a executer)

- SEC-01 : Scope user obligatoire pour chargement message.
- SEC-02 : Policy destroy commentaire (owner/admin).
- SEC-03 : Activation `force_ssl` + validation reverse proxy.
- SEC-04 : Configuration `config.hosts`.
- SEC-05 : CSP report-only + endpoint rapport + enforce.
- SEC-06 : Desactivation `admin-setup` apres bootstrap.
- SEC-07 : Standardisation suppressions en `DELETE`.
- SEC-08 : Ajout tests integration securite critiques.
- SEC-09 : Dashboard securite (401/403/429/CSP).
- SEC-10 : Runbook incidents + rotation secrets.

---

## 8) Conclusion

Le niveau actuel est celui d'une base serieuse mais encore "MVP securise partiellement".  
En appliquant ce plan (P0/P1/P2), le projet passe a un niveau nettement plus robuste : risques critiques traites rapidement, plateforme durcie en production, et securite integree durablement dans le cycle de livraison.
