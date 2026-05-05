# Audit de l'etat de l'application - StudyLink

Date : 2026-05-05  
Branche observee : `docs/audit`  
Reference principale : etat local + historique Git recent

---

## 1) Etat global

L'application est globalement bien structuree et exploitable, avec une base Rails moderne (Rails 8.1), une architecture claire (espaces `admin`, `mentor`, moderation, temps reel), et une CI deja en place.

### Constat rapide
- Working tree non propre sur la branche courante pendant l'audit initial (`db/schema.rb`, `package-lock.json`, `yarn.lock` modifies localement).
- Les modifications locales observes etaient majoritairement techniques (dependances JS + schema DB), sans gros changement metier non commit au meme moment.
- Aucun probleme de lint IDE detecte pendant l'audit.

---

## 2) Dernieres modifications observees

### Commits recents marquants
- `ae509a6` - reparation formulaires
  - changement du formulaire de post React (`PostForm`)
  - ajustements montage React (`react_mount.js`)
  - ajustements modal Stimulus
  - mises a jour vues feed/conversations
- `8149684` / `ca475f1` - logo / deplacement asset icon
- `793d2d9` - gestion globale `RecordNotFound` dans `ApplicationController`

### Modifications techniques observees lors de l'audit
- `package-lock.json` / `yarn.lock`
  - ajout de `react`, `react-dom`, `@monaco-editor/react`
  - update `@rails/actioncable`
- `db/schema.rb`
  - ajustements de types (`bigint`), index renommes
  - contraintes renforcees sur `resources` (`title` et `body` non null)

---

## 3) Points forts

- CI structuree : securite (`brakeman`, `bundler-audit`), style (`rubocop`), tests unitaires + system tests.
- Architecture lisible et modulaire : separation des responsabilites cote controleurs et domaines.
- Temps reel robuste : Action Cable + fallback Turbo Streams.
- Mecanismes securite de base presents : Devise, `Rack::Attack`, gestion centralisee de `RecordNotFound`.

---

## 4) Points faibles / risques a corriger

### Critique
#### Controle d'acces insuffisant sur messages
Dans `MessagesController`, le chargement d'un message par `Message.find(params[:id])` sans scope utilisateur + absence de garde d'auteur sur certaines actions expose un risque d'acces/suppression non autorisee.

### Eleve
#### Controle d'acces incomplet sur commentaires
Dans `CommentsController`, `destroy` n'est pas couvert par la verification d'auteur (`authorize_author!` uniquement sur `edit/update`).

### Eleve
#### Incoherences routing `delete` custom
Les routes utilisent `post :delete` sur plusieurs ressources, mais les controleurs ne sont pas homogenes (`destroy` vs alias `delete`). Risque d'actions non trouvees/regressions.

### Moyen
#### Couverture tests trop orientee modeles
Peu de tests d'integration/controleurs sur les flux critiques (authz, suppressions, messagerie temps reel, formulaires React/Turbo).

### Moyen
#### Documentation technique partiellement designee
Le README mentionne encore une stack front surtout Stimulus/Tailwind, alors que React/Monaco est desormais present.

---

## 5) Priorites d'amelioration (P0 -> P2)

### P0 (immediat)
1. Securiser `MessagesController` (scope conversation/utilisateur + garde d'auteur sur suppression/lecture).
2. Securiser `CommentsController#destroy` avec verification d'auteur.
3. Revoir l'exposition des actions de suppression (coherence routes/controleurs).

### P1 (court terme)
4. Uniformiser la strategie REST (preferer `DELETE` standard) ou standardiser proprement les alias `delete`.
5. Ajouter tests d'integration sur les cas d'acces interdit (utilisateur A/B).

### P2 (moyen terme)
6. Harmoniser la gestion des dependances JS (eviter derives npm/yarn lockfiles).
7. Mettre a jour README et conventions d'architecture front.

---

## 6) Conclusion

L'application repose sur une base solide (architecture, CI, fonctionnalites riches), mais presente des vulnerabilites d'autorisation sur des actions sensibles (messages/commentaires) qui doivent etre traitees en priorite avant d'ajouter de nouvelles fonctionnalites.
