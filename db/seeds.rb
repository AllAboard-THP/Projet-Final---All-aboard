puts "Seeding StudyLink demo data..."

# ——— RESET CONTENU (pas les users) ———

Message.destroy_all
ConversationParticipant.destroy_all
Conversation.destroy_all
Bookmark.destroy_all
Like.destroy_all
Comment.destroy_all
PostTag.destroy_all
Post.destroy_all
ResourceTag.destroy_all
Resource.destroy_all
Event.destroy_all
EventCandidate.destroy_all
SubjectRequest.destroy_all
MentorSubject.destroy_all
Subject.destroy_all

# ——— SUBJECTS ———

subjects = [
  { name: "HTML / CSS",            slug: "html-css",                description: "Intégration web, flexbox, grid, animations, responsive design...", icon: "fa-code",          accent_color: "#f97316" },
  { name: "JavaScript",            slug: "javascript",              description: "ES6+, DOM, async/await, React, Vue, Node.js...",                    icon: "fa-js",            accent_color: "#facc15" },
  { name: "Python",                slug: "python",                  description: "Scripts, Django, Flask, data science, automatisation...",            icon: "fa-python",        accent_color: "#60a5fa" },
  { name: "Ruby / Rails",          slug: "ruby-rails",              description: "Ruby, Ruby on Rails, MVC, ActiveRecord, Hotwire...",                icon: "fa-gem",           accent_color: "#f87171" },
  { name: "Bases de données",      slug: "bases-de-donnees",        description: "SQL, PostgreSQL, MySQL, NoSQL, modélisation, requêtes...",           icon: "fa-database",      accent_color: "#a78bfa" },
  { name: "Intelligence Artificielle", slug: "intelligence-artificielle", description: "Machine learning, deep learning, LLMs, prompt engineering...", icon: "fa-brain",         accent_color: "#4ade80" },
  { name: "DevOps & Cloud",        slug: "devops-cloud",            description: "Docker, CI/CD, Kubernetes, AWS, déploiement, Linux...",             icon: "fa-cloud",         accent_color: "#22d3ee" },
  { name: "Cybersécurité",         slug: "cybersecurite",           description: "OWASP, pentest, CTF, cryptographie, Kali Linux...",                 icon: "fa-shield-halved", accent_color: "#c084fc" },
  { name: "Algorithmique",         slug: "algorithmique",           description: "Structures de données, tri, graphes, complexité, LeetCode...",       icon: "fa-diagram-project", accent_color: "#fb923c" },
].map { |attrs| Subject.create!(attrs) }.index_by(&:slug)

# ——— USERS (find_or_create : préserve les comptes existants) ———

def upsert_user(email:, password:, full_name:, **attrs)
  user = User.find_or_initialize_by(email: email)
  if user.new_record?
    user.assign_attributes(password: password, password_confirmation: password, full_name: full_name, **attrs)
    user.save!
  else
    user.update!(full_name: full_name, **attrs)
  end
  user
end

admin = upsert_user(
  email: "admin@studylink.test", password: "Admin1234!",
  full_name: "Admin StudyLink",
  headline: "Administrateur de la plateforme",
  education_level: "N/A",
  bio: "Compte administrateur. Gestion de la plateforme, modération et contenu.",
  avatar_url: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop",
  role: "admin"
)

lucas = upsert_user(
  email: "lucas@studylink.test", password: "Lucas1234!",
  full_name: "Lucas M.",
  headline: "Ingénieur full-stack — Mentor JS & Ruby on Rails",
  education_level: "Master Informatique",
  bio: "5 ans d'expérience en développement web. Je partage mes connaissances sur React, Ruby on Rails, les APIs REST et les bonnes pratiques de code.",
  avatar_url: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop",
  rating: 4.9, mentor: true
)

sofia = upsert_user(
  email: "sofia@studylink.test", password: "Sofia1234!",
  full_name: "Sofia T.",
  headline: "Data Engineer — Mentor Python & IA",
  education_level: "Master Data Science",
  bio: "Spécialisée en machine learning et pipelines de données. J'aide sur Python, pandas, scikit-learn et les LLMs. Passionnée par l'IA éthique.",
  avatar_url: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop",
  rating: 4.8, mentor: true
)

kevin = upsert_user(
  email: "kevin@studylink.test", password: "Kevin1234!",
  full_name: "Kévin A.",
  headline: "Ingénieur DevOps — Mentor Cloud & Cybersécurité",
  education_level: "Licence Pro Systèmes Réseaux",
  bio: "5 ans chez un hébergeur cloud. Je couvre Docker, Kubernetes, Linux hardening et les bases du pentesting. Certifié AWS Solutions Architect.",
  avatar_url: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=100&h=100&fit=crop",
  rating: 4.7, mentor: true
)

hugo = upsert_user(
  email: "hugo@studylink.test", password: "Hugo1234!",
  full_name: "Hugo B.",
  headline: "BTS SIO — Développement d'applications web",
  education_level: "BTS SIO",
  bio: "En formation dev web. Je travaille sur des projets React et commence Rails. Passionné par la cybersécurité.",
  avatar_url: "https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100&h=100&fit=crop",
  rating: 4.3
)

camille = upsert_user(
  email: "camille@studylink.test", password: "Camille1234!",
  full_name: "Camille R.",
  headline: "Licence Informatique — Spécialisation IA",
  education_level: "Licence 3 Informatique",
  bio: "Je me spécialise en intelligence artificielle. Je bidouille des modèles PyTorch et explore le prompt engineering.",
  avatar_url: "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=100&h=100&fit=crop",
  rating: 4.5
)

thomas = upsert_user(
  email: "thomas@studylink.test", password: "Thomas1234!",
  full_name: "Thomas D.",
  headline: "Autodidacte — Python & DevOps",
  education_level: "Autodidacte",
  bio: "Reconversion depuis 1 an. Je maîtrise Python, Linux et commence Docker/Kubernetes. Toujours prêt à partager.",
  avatar_url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop",
  rating: 4.6
)

marie = upsert_user(
  email: "marie@studylink.test", password: "Marie1234!",
  full_name: "Marie L.",
  headline: "Développeuse front-end junior — HTML/CSS/JS",
  education_level: "Bootcamp Le Wagon",
  bio: "Sortie du Wagon il y a 3 mois. Je perfectionne mon CSS, j'apprends React et je cherche mon premier poste.",
  avatar_url: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop",
  rating: 4.4
)

romain = upsert_user(
  email: "romain@studylink.test", password: "Romain1234!",
  full_name: "Romain V.",
  headline: "Étudiant en Master Cybersécurité",
  education_level: "Master 1 Sécurité Informatique",
  bio: "Passionné de CTF et de sécurité offensive. J'apprends le pentesting web, la cryptographie et les techniques de reverse engineering.",
  avatar_url: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop",
  rating: 4.2
)

lea = upsert_user(
  email: "lea@studylink.test", password: "Lea12345!",
  full_name: "Léa P.",
  headline: "DUT Informatique — Bases de données & Backend",
  education_level: "DUT Informatique",
  bio: "Spécialisée en bases de données et backend Python/Django. Je cherche un stage pour valider mon DUT.",
  avatar_url: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100&h=100&fit=crop",
  rating: 4.1
)

# ——— COMPÉTENCES MENTORS ———

lucas.competences = Subject.where(slug: %w[javascript ruby-rails html-css])
sofia.competences  = Subject.where(slug: %w[python intelligence-artificielle bases-de-donnees algorithmique])
kevin.competences  = Subject.where(slug: %w[devops-cloud cybersecurite])

# ——— POSTS ———

def make_post(attrs)
  tag_list = attrs.delete(:tag_list)
  post = Post.create!(attrs)
  post.sync_tags!(tag_list)
  post
end

posts = []

posts << make_post(
  user: hugo, subject: subjects["javascript"],
  title: "Problème avec React useEffect et boucle infinie",
  body: "Mon composant re-render en boucle à cause de useEffect. Je comprends pas pourquoi mon state se met à jour sans arrêt alors que je n'ai rien changé dans les dépendances.",
  code_snippet: "useEffect(() => {\n  fetchData();\n}, [data]); // data change à chaque render !",
  code_language: "javascript", urgent: true,
  education_level: "BTS SIO", tag_list: "React, Hooks, useEffect",
  created_at: 2.hours.ago
)

posts << make_post(
  user: marie, subject: subjects["html-css"],
  title: "Mon flexbox ne centre pas verticalement sur mobile",
  body: "J'essaie de centrer un élément verticalement avec flexbox mais ça marche sur desktop et pas sur mobile. J'ai pourtant mis align-items: center et justify-content: center.",
  code_snippet: ".container {\n  display: flex;\n  align-items: center;\n  justify-content: center;\n  height: 100vh;\n}",
  code_language: "css", urgent: false,
  education_level: "Bootcamp", tag_list: "CSS, Flexbox, Responsive",
  created_at: 5.hours.ago
)

posts << make_post(
  user: thomas, subject: subjects["python"],
  title: "KeyError sur un dictionnaire — je comprends pas pourquoi",
  body: "Mon script plante avec KeyError alors que j'ai vérifié que la clé existe. Le problème arrive seulement quand je parse un fichier JSON externe.",
  code_snippet: "data = json.load(f)\nprint(data['user']['email'])  # KeyError: 'user'",
  code_language: "python", urgent: true,
  education_level: "Autodidacte", tag_list: "Python, JSON, Dictionnaire",
  created_at: 1.day.ago
)

posts << make_post(
  user: camille, subject: subjects["intelligence-artificielle"],
  title: "Comment éviter l'overfitting sur mon modèle PyTorch ?",
  body: "Mon modèle de classification a 97% d'accuracy sur le train set mais seulement 63% sur le test set. J'ai essayé de réduire les epochs mais le gap reste énorme.",
  code_snippet: "self.fc1 = nn.Linear(784, 512)\nself.fc2 = nn.Linear(512, 256)\nself.fc3 = nn.Linear(256, 10)\n# Pas de dropout ni de batch norm",
  code_language: "python", urgent: false,
  education_level: "Licence 3", tag_list: "PyTorch, Overfitting, Deep Learning",
  created_at: 9.hours.ago
)

posts << make_post(
  user: hugo, subject: subjects["devops-cloud"],
  title: "Mon container Docker ne trouve pas l'image en production",
  body: "En local ça tourne parfaitement mais sur le serveur de prod j'ai une erreur 'image not found'. J'utilise docker-compose et l'image est sur Docker Hub.",
  code_snippet: "services:\n  app:\n    image: monuser/monapp:latest\n# Error: No such image: monuser/monapp:latest",
  code_language: "yaml", urgent: true,
  education_level: "BTS SIO", tag_list: "Docker, Docker Hub, Production",
  created_at: 3.hours.ago
)

posts << make_post(
  user: marie, subject: subjects["ruby-rails"],
  title: "Différence entre has_many :through et has_and_belongs_to_many ?",
  body: "Dans Rails, j'hésite entre has_many :through et has_and_belongs_to_many pour une relation Users ↔ Projets. Quelle est la bonne pratique et dans quel cas utiliser l'un vs l'autre ?",
  code_snippet: "# Option A\nhas_many :participations\nhas_many :projects, through: :participations\n\n# Option B\nhas_and_belongs_to_many :projects",
  code_language: "ruby", urgent: false,
  education_level: "Bootcamp", tag_list: "Rails, ActiveRecord, Associations",
  created_at: 2.days.ago
)

posts << make_post(
  user: romain, subject: subjects["cybersecurite"],
  title: "XSS stocké vs réfléchi — quelle différence concrète ?",
  body: "Je prépare un CTF et je ne comprends pas bien la différence entre XSS stocké et réfléchi en termes d'exploitation. Pouvez-vous expliquer avec des exemples concrets ?",
  code_snippet: "<!-- XSS réfléchi dans un paramètre GET -->\nhttps://site.com/search?q=<script>alert(1)</script>",
  code_language: "html", urgent: false,
  education_level: "Master 1", tag_list: "XSS, OWASP, CTF",
  created_at: 6.hours.ago
)

posts << make_post(
  user: lea, subject: subjects["bases-de-donnees"],
  title: "Optimiser une requête SQL avec plusieurs jointures",
  body: "Ma requête avec 3 JOIN est très lente sur une table de 500k lignes. J'ai ajouté des index mais le EXPLAIN ANALYZE montre toujours un sequential scan.",
  code_snippet: "SELECT u.name, p.title, c.body\nFROM users u\nJOIN posts p ON p.user_id = u.id\nJOIN comments c ON c.post_id = p.id\nWHERE u.created_at > '2024-01-01'\nORDER BY p.created_at DESC;",
  code_language: "sql", urgent: true,
  education_level: "DUT", tag_list: "SQL, Index, Performance",
  created_at: 4.hours.ago
)

posts << make_post(
  user: thomas, subject: subjects["algorithmique"],
  title: "Algorithme de Dijkstra — je n'arrive pas à l'implémenter",
  body: "Je comprends le principe théorique mais mon implémentation de Dijkstra donne des résultats faux sur les graphes avec des poids différents. Voici mon code Python.",
  code_snippet: "def dijkstra(graph, start):\n    distances = {node: float('inf') for node in graph}\n    distances[start] = 0\n    visited = set()\n    # La suite ne fonctionne pas correctement...",
  code_language: "python", urgent: false,
  education_level: "Autodidacte", tag_list: "Graphes, Dijkstra, Algorithmique",
  created_at: 12.hours.ago
)

posts << make_post(
  user: hugo, subject: subjects["javascript"],
  title: "Comment fonctionne le prototype chain en JavaScript ?",
  body: "Je ne comprends pas du tout la notion de prototype en JS. Quelle est la différence avec les classes ? Et pourquoi mes méthodes ne sont parfois pas trouvées ?",
  code_snippet: "function Animal(name) {\n  this.name = name;\n}\nAnimal.prototype.speak = function() {\n  console.log(this.name + ' makes a noise.');\n};",
  code_language: "javascript", urgent: false,
  education_level: "BTS SIO", tag_list: "JavaScript, Prototype, POO",
  created_at: 1.day.ago
)

posts << make_post(
  user: camille, subject: subjects["python"],
  title: "Différence entre multiprocessing et threading en Python",
  body: "J'ai un script qui fait du scraping et des calculs lourds. Je veux le paralléliser mais je ne sais pas si utiliser threading ou multiprocessing. Le GIL me perd complètement.",
  code_snippet: "# Lequel choisir ?\nimport threading   # ou bien...\nimport multiprocessing",
  code_language: "python", urgent: false,
  education_level: "Licence 3", tag_list: "Python, Multiprocessing, Threading, GIL",
  created_at: 8.hours.ago
)

posts << make_post(
  user: romain, subject: subjects["devops-cloud"],
  title: "Configurer HTTPS avec Nginx et Let's Encrypt sur VPS",
  body: "J'ai un VPS Ubuntu avec Nginx qui sert mon app. Je veux configurer HTTPS gratuit avec Let's Encrypt mais certbot plante avec une erreur de port 80.",
  code_snippet: "$ sudo certbot --nginx -d monsite.com\nFailed to connect to 0.0.0.0:80 for tls-sni-01 challenge",
  code_language: "bash", urgent: true,
  education_level: "Master 1", tag_list: "Nginx, HTTPS, Let's Encrypt, VPS",
  created_at: 30.minutes.ago
)

posts << make_post(
  user: lea, subject: subjects["ruby-rails"],
  title: "ActiveRecord N+1 query — comment le détecter et corriger ?",
  body: "Mon app Rails est lente et dans les logs je vois des centaines de requêtes SQL similaires. Comment détecter les N+1 et les corriger avec includes ?",
  code_snippet: "# Ce code génère N+1\n@posts = Post.all\n@posts.each { |p| puts p.user.name }",
  code_language: "ruby", urgent: false,
  education_level: "DUT", tag_list: "Rails, ActiveRecord, N+1, Performance",
  created_at: 2.days.ago
)

posts << make_post(
  user: marie, subject: subjects["javascript"],
  title: "Async/await vs Promises — quand utiliser quoi ?",
  body: "Je maîtrise les Promises mais je vois partout async/await dans les tutoriels récents. Y a-t-il des cas où les Promises restent préférables ? Et comment gérer les erreurs en parallèle ?",
  code_snippet: "// Style Promise\nfetch(url)\n  .then(r => r.json())\n  .then(data => console.log(data))\n  .catch(console.error);\n\n// Style async/await\nconst data = await fetch(url).then(r => r.json());",
  code_language: "javascript", urgent: false,
  education_level: "Bootcamp", tag_list: "JavaScript, Async, Promises, ES6",
  created_at: 3.days.ago
)

posts << make_post(
  user: thomas, subject: subjects["bases-de-donnees"],
  title: "Quand utiliser une transaction SQL ?",
  body: "Je comprends le concept ACID mais dans la pratique je ne sais pas quand wrapper mes requêtes dans une transaction. Mon app Python/Flask gère des paiements.",
  code_snippet: "# Avec ou sans transaction ?\ncursor.execute('UPDATE accounts SET balance = balance - 100 WHERE id = 1')\ncursor.execute('UPDATE accounts SET balance = balance + 100 WHERE id = 2')",
  code_language: "python", urgent: false,
  education_level: "Autodidacte", tag_list: "SQL, Transaction, ACID",
  created_at: 5.days.ago
)

# ——— COMMENTS ———

Comment.create!(post: posts[0], user: lucas,
  body: "Le souci vient des dépendances : fetchData modifie `data`, ce qui relance l'effet → boucle infinie. Essaie `[]` pour un appel unique au montage, ou useCallback pour stabiliser fetchData.",
  created_at: 1.hour.ago)
Comment.create!(post: posts[0], user: thomas,
  body: "Pour compléter Lucas : si tu as besoin de relancer fetchData quand une vraie condition change, utilise un ID ou une valeur primitive comme dépendance, jamais un objet directement.",
  created_at: 45.minutes.ago)
Comment.create!(post: posts[0], user: marie,
  body: "J'avais exactement le même problème la semaine dernière ! Le conseil de Lucas fonctionne parfaitement, useCallback a tout résolu pour moi.",
  created_at: 30.minutes.ago)

Comment.create!(post: posts[1], user: lucas,
  body: "Le problème vient sûrement de l'élément parent. Si son parent n'a pas de hauteur définie, `height: 100vh` sur .container ne suffira pas. Vérifie que html, body ont bien height: 100%.",
  created_at: 3.hours.ago)
Comment.create!(post: posts[1], user: kevin,
  body: "Sur mobile, attention aussi aux barres de navigation du navigateur qui réduisent la hauteur réelle. Utilise `height: 100dvh` (dynamic viewport height) au lieu de `100vh` pour iOS/Android.",
  created_at: 2.hours.ago)

Comment.create!(post: posts[2], user: sofia,
  body: "Le JSON externe a probablement une structure différente de ce que tu attends. Fais un `print(data.keys())` avant d'accéder à 'user'. Utilise aussi `data.get('user', {})` pour éviter le KeyError.",
  created_at: 20.hours.ago)
Comment.create!(post: posts[2], user: camille,
  body: "Ajoute aussi une validation de schéma avec `jsonschema` ou `pydantic`. Ça t'évitera ce type d'erreur à la runtime en validant la structure dès l'entrée.",
  created_at: 18.hours.ago)

Comment.create!(post: posts[3], user: sofia,
  body: "Overfitting classique. Ajoute du Dropout (0.3-0.5) entre tes couches, du BatchNorm, et essaie L2 regularization (weight_decay dans ton optimizer). Augmente aussi ton dataset si possible.",
  created_at: 7.hours.ago)
Comment.create!(post: posts[3], user: thomas,
  body: "Data augmentation peut aussi beaucoup aider si tu travailles sur des images. Torchvision.transforms offre plein d'options (rotation, flip, brightness) pour diversifier ton dataset.",
  created_at: 6.hours.ago)

Comment.create!(post: posts[4], user: lucas,
  body: "Tu as oublié de faire `docker pull monuser/monapp:latest` sur le serveur avant le docker-compose up. L'image n'est pas automatiquement téléchargée si elle n'est pas en cache local.",
  created_at: 2.hours.ago)
Comment.create!(post: posts[4], user: kevin,
  body: "Autre piste : vérifie que tu es bien connecté à Docker Hub sur ton serveur (`docker login`). Les images privées ne se téléchargent pas sans authentification.",
  created_at: 90.minutes.ago)

Comment.create!(post: posts[5], user: lucas,
  body: "Règle générale : préfère toujours has_many :through. HABTM ne te permet pas d'ajouter des attributs sur la table de jointure (ex: rôle dans un projet, date d'invitation...). HMT est plus flexible.",
  created_at: 1.day.ago)

Comment.create!(post: posts[6], user: kevin,
  body: "XSS réfléchi : le payload vient de la requête HTTP (URL, formulaire) et est renvoyé immédiatement. XSS stocké : le payload est sauvegardé en base et servi à tous les visiteurs — bien plus dangereux.",
  created_at: 4.hours.ago)
Comment.create!(post: posts[6], user: romain,
  body: "Merci ! Et pour le DOM-based XSS alors ? C'est encore différent ?",
  created_at: 3.hours.ago)
Comment.create!(post: posts[6], user: kevin,
  body: "DOM-based : le payload ne passe jamais par le serveur, il est exécuté côté client via JavaScript (document.location, innerHTML...). Plus difficile à détecter par les WAF.",
  created_at: 2.hours.ago)

Comment.create!(post: posts[7], user: sofia,
  body: "Ton problème vient probablement des colonnes dans WHERE et ORDER BY. Ajoute un index composite sur (user_id, created_at) sur la table posts. Le EXPLAIN ANALYZE te montrera un Index Scan à la place du Seq Scan.",
  created_at: 3.hours.ago)
Comment.create!(post: posts[7], user: thomas,
  body: "Tu peux aussi utiliser `EXPLAIN (ANALYZE, BUFFERS)` pour voir les I/O. Et si la requête est fréquente, envisage une vue matérialisée.",
  created_at: 2.hours.ago)

Comment.create!(post: posts[8], user: sofia,
  body: "Ton bug vient de la gestion de la file de priorité. Utilise `heapq` en Python pour gérer efficacement le nœud avec la distance minimale. Sans ça, Dijkstra devient O(V²) au lieu de O((V+E)logV).",
  created_at: 10.hours.ago)

Comment.create!(post: posts[11], user: kevin,
  body: "L'erreur vient probablement du fait que le port 80 est déjà occupé (Nginx tourne). Arrête Nginx avant de lancer certbot : `sudo systemctl stop nginx`, puis `sudo certbot certonly --standalone -d monsite.com`.",
  created_at: 20.minutes.ago)

Comment.create!(post: posts[12], user: lucas,
  body: "Utilise la gem `bullet` en développement, elle détecte automatiquement les N+1 et te suggère les `includes` à ajouter. En prod, `rack-mini-profiler` peut aussi t'aider.",
  created_at: 1.day.ago)

# ——— LIKES ———

[
  [lucas,  posts[0]], [thomas, posts[0]], [marie,  posts[0]],
  [sofia,  posts[1]], [kevin,  posts[1]],
  [marie,  posts[2]], [camille, posts[2]],
  [hugo,   posts[3]], [lea,    posts[3]],
  [lucas,  posts[4]], [thomas, posts[4]], [kevin, posts[4]],
  [sofia,  posts[5]], [camille, posts[5]],
  [kevin,  posts[6]], [thomas, posts[6]],
  [sofia,  posts[7]], [lea,    posts[7]],
  [lucas,  posts[8]],
  [sofia,  posts[9]], [thomas, posts[9]],
  [kevin,  posts[10]],
  [romain, posts[11]], [kevin, posts[11]],
  [lucas,  posts[12]], [sofia, posts[12]],
  [lucas,  posts[13]], [sofia, posts[13]],
  [sofia,  posts[14]],
].each { |user, post| Like.find_or_create_by!(user: user, post: post) }

# ——— BOOKMARKS ———

[
  [hugo,   posts[0]],
  [marie,  posts[1]], [romain, posts[1]],
  [camille, posts[3]], [lea,   posts[3]],
  [thomas, posts[5]],
  [romain, posts[6]],
  [lea,    posts[7]],
  [hugo,   posts[9]],
  [romain, posts[11]],
  [marie,  posts[12]],
].each { |user, post| Bookmark.find_or_create_by!(user: user, post: post) }

# ——— RESOURCES ———

Resource.create!(
  user: lucas, subject: subjects["javascript"],
  title: "Comprendre les closures en JavaScript",
  body: <<~BODY,
    # Les closures en JavaScript

    Une closure est une fonction qui « se souvient » des variables de son environnement lexical, même après que cet environnement ait disparu.

    ## Exemple simple

    ```javascript
    function compteur() {
      let count = 0;
      return function() {
        count++;
        return count;
      };
    }

    const inc = compteur();
    inc(); // 1
    inc(); // 2
    ```

    ## Cas d'usage fréquents
    - Encapsulation (variables privées)
    - Mémorisation (memoization)
    - Callbacks avec contexte

    ## Piège classique : closures dans une boucle

    ```javascript
    for (var i = 0; i < 3; i++) {
      setTimeout(() => console.log(i), 100); // Affiche 3, 3, 3 !
    }
    // Solution : utiliser let
    ```
  BODY
  status: :published, created_at: 3.days.ago
)

Resource.create!(
  user: lucas, subject: subjects["ruby-rails"],
  title: "Les fondamentaux de Git en 10 commandes",
  body: <<~BODY,
    # Les fondamentaux de Git

    ## Initialiser et cloner
    - `git init` — initialise un dépôt local
    - `git clone <url>` — clone un dépôt distant

    ## Travailler au quotidien
    - `git status` — état de l'arbre de travail
    - `git add .` — staging de tous les fichiers modifiés
    - `git commit -m "message"` — créer un commit

    ## Branches
    - `git checkout -b ma-branche` — créer et basculer sur une branche
    - `git merge ma-branche` — fusionner dans la courante

    ## Synchronisation
    - `git pull` — récupérer et fusionner les changements distants
    - `git push` — pousser vers le dépôt distant

    ## Conseil
    Commitez souvent, avec des messages clairs au présent impératif.
  BODY
  status: :published, created_at: 1.day.ago
)

Resource.create!(
  user: sofia, subject: subjects["python"],
  title: "Complexité algorithmique — O(n) expliqué simplement",
  body: <<~BODY,
    # La complexité algorithmique

    | Notation | Nom | Exemple |
    |---|---|---|
    | O(1) | Constante | Accès tableau par index |
    | O(log n) | Logarithmique | Recherche dichotomique |
    | O(n) | Linéaire | Parcourir un tableau |
    | O(n²) | Quadratique | Boucle imbriquée |

    ## Règles pratiques
    1. Ignorer les constantes : O(3n) = O(n)
    2. Garder le terme dominant : O(n² + n) = O(n²)

    ## Exemple concret

    ```python
    # O(n²) — à éviter sur de grandes données
    def contient_doublon(lst):
        for i in range(len(lst)):
            for j in range(i+1, len(lst)):
                if lst[i] == lst[j]:
                    return True

    # O(n) — bien mieux !
    def contient_doublon_v2(lst):
        return len(lst) != len(set(lst))
    ```
  BODY
  status: :published, created_at: 2.days.ago
)

Resource.create!(
  user: sofia, subject: subjects["intelligence-artificielle"],
  title: "Overfitting vs Underfitting — comprendre et corriger",
  body: <<~BODY,
    # Overfitting & Underfitting

    ## Overfitting
    Le modèle mémorise les données d'entraînement au lieu de généraliser.
    - **Symptôme** : haute accuracy train, faible accuracy test
    - **Solutions** : Dropout, Regularisation L1/L2, Data Augmentation, Early Stopping

    ## Underfitting
    Le modèle est trop simple.
    - **Symptôme** : faible accuracy partout
    - **Solutions** : modèle plus complexe, plus d'epochs, meilleur feature engineering

    ## La règle d'or

    ```python
    from sklearn.model_selection import train_test_split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    ```

    ## Checklist
    - [ ] Gap train/test < 5% ?
    - [ ] Testé sur des données jamais vues ?
    - [ ] Validation croisée effectuée ?
  BODY
  status: :published, created_at: 5.hours.ago
)

Resource.create!(
  user: kevin, subject: subjects["devops-cloud"],
  title: "Docker en 5 étapes — de zéro à la production",
  body: <<~BODY,
    # Docker de zéro à la production

    ## 1. Concepts clés
    - **Image** : blueprint immuable de l'application
    - **Container** : instance en cours d'exécution d'une image
    - **Registry** : dépôt d'images (Docker Hub, GitHub Registry...)

    ## 2. Dockerfile minimal pour une app web

    ```dockerfile
    FROM ruby:3.4-alpine
    WORKDIR /app
    COPY Gemfile* ./
    RUN bundle install
    COPY . .
    EXPOSE 3000
    CMD ["bin/rails", "server", "-b", "0.0.0.0"]
    ```

    ## 3. Build & run

    ```bash
    docker build -t mon-app .
    docker run -p 3000:3000 mon-app
    ```

    ## 4. Docker Compose pour le dev

    ```yaml
    services:
      app:
        build: .
        ports: ["3000:3000"]
      db:
        image: postgres:17
        environment:
          POSTGRES_PASSWORD: secret
    ```

    ## 5. Bonnes pratiques prod
    - Utilise des images Alpine (légères)
    - Ne stocke jamais de secrets dans l'image
    - Un container = un seul process
  BODY
  status: :published, created_at: 4.days.ago
)

Resource.create!(
  user: kevin, subject: subjects["cybersecurite"],
  title: "OWASP Top 10 — les 10 failles web à connaître absolument",
  body: <<~BODY,
    # OWASP Top 10

    Le Top 10 OWASP liste les risques de sécurité web les plus critiques.

    ## 1. Injection (SQL, NoSQL, OS)
    ```sql
    -- Vulnérable
    SELECT * FROM users WHERE name = '$input';
    -- Sécurisé : requête paramétrée
    SELECT * FROM users WHERE name = ?;
    ```

    ## 2. Broken Authentication
    Sessions mal gérées, mots de passe faibles, absence de 2FA.

    ## 3. XSS (Cross-Site Scripting)
    Injection de scripts dans les pages vues par d'autres utilisateurs.

    ## 4. IDOR (Insecure Direct Object Reference)
    Accéder à `/user/42` quand on est l'user 1.

    ## 5. Mauvaise configuration de sécurité
    Headers HTTP manquants, ports ouverts, erreurs verboses en prod.

    ## Outils de test
    - **OWASP ZAP** — scanner automatique
    - **Burp Suite** — proxy d'interception
    - **sqlmap** — test d'injection SQL
  BODY
  status: :published, created_at: 6.days.ago
)

Resource.create!(
  user: lucas, subject: subjects["javascript"],
  title: "Guide pratique : async/await et gestion d'erreurs",
  body: <<~BODY,
    # Async/await en JavaScript

    ## Pourquoi async/await ?
    async/await est du sucre syntaxique sur les Promises. Le code devient linéaire et lisible.

    ## Pattern de base

    ```javascript
    async function fetchUser(id) {
      try {
        const response = await fetch(`/api/users/${id}`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        return await response.json();
      } catch (error) {
        console.error('Erreur:', error.message);
        return null;
      }
    }
    ```

    ## Parallélisme avec Promise.all

    ```javascript
    // Séquentiel (lent)
    const user = await fetchUser(1);
    const posts = await fetchPosts(1);

    // Parallèle (rapide)
    const [user, posts] = await Promise.all([
      fetchUser(1),
      fetchPosts(1)
    ]);
    ```

    ## Quand rester sur .then() ?
    Pour chaîner des opérations indépendantes ou dans des contextes non-async.
  BODY
  status: :published, created_at: 2.days.ago
)

# ——— EVENTS ———

[
  { title: "Hackathon 48h — IA & Développement Durable",
    description: "48 heures pour construire une solution tech au service de l'environnement. Équipes de 2 à 5. Prix : 5 000 €.",
    event_type: "hackathon", starts_at: 3.weeks.from_now, ends_at: 3.weeks.from_now + 2.days,
    location: "Station F, Paris 13e", organizer: "GreenTech Challenge", online: false,
    external_url: "https://example.com/hackathon-ia", subject: subjects["intelligence-artificielle"] },
  { title: "Conférence — DevOps & Cloud Native 2025",
    description: "Une journée autour de Kubernetes, CI/CD, GitOps et observabilité. 400 participants attendus.",
    event_type: "conference", starts_at: 5.weeks.from_now, ends_at: 5.weeks.from_now,
    location: "La Défense, Paris", organizer: "CloudCraft Community", online: false,
    external_url: "https://example.com/devops-cloud-native", subject: subjects["devops-cloud"] },
  { title: "Meetup — Ruby on Rails Paris #42",
    description: "Talks de 15 min sur Rails 8, Hotwire et les pratiques modernes. Bières et networking.",
    event_type: "meetup", starts_at: 10.days.from_now, ends_at: 10.days.from_now,
    location: "Le Wagon Paris, Paris 9e", organizer: "Paris.rb", online: false,
    external_url: "https://example.com/paris-rb-42", subject: subjects["ruby-rails"] },
  { title: "Webinaire — Introduction à la cybersécurité offensive",
    description: "Bases du pentesting : OWASP Top 10, outils Kali Linux, premiers CTF. Pour étudiants BTS/Licence.",
    event_type: "webinar", starts_at: 1.week.from_now, ends_at: 1.week.from_now,
    location: nil, organizer: "SecuriLearn", online: true,
    external_url: "https://example.com/webinaire-cybersec", subject: subjects["cybersecurite"] },
  { title: "Hackathon Python — Data & Visualisation",
    description: "Résoudre des problèmes data réels avec Python, pandas et matplotlib. Prix : stage et matériel.",
    event_type: "hackathon", starts_at: 6.weeks.from_now, ends_at: 6.weeks.from_now + 1.day,
    location: "Campus Numérique, Lyon", organizer: "PyFrance", online: false,
    external_url: "https://example.com/hackathon-python", subject: subjects["python"] },
  { title: "Webinaire — Débuter avec React en 2025",
    description: "React moderne : hooks, Context API, React Query, Server Components. Démo live et Q&A.",
    event_type: "webinar", starts_at: 3.days.from_now, ends_at: 3.days.from_now,
    location: nil, organizer: "JS Nation France", online: true,
    external_url: "https://example.com/webinaire-react", subject: subjects["javascript"] },
  { title: "CTF étudiant — Capture The Flag Paris",
    description: "Compétition de cybersécurité en équipes de 3. Web, crypto, reverse, forensics. Classement national.",
    event_type: "hackathon", starts_at: 2.weeks.from_now, ends_at: 2.weeks.from_now + 1.day,
    location: "EPITA, Paris", organizer: "HackEPITA", online: false,
    external_url: "https://example.com/ctf-paris", subject: subjects["cybersecurite"] },
  { title: "Meetup — SQL & Bases de données avancées",
    description: "Index, partitionnement, requêtes fenêtrées, et optimisation de requêtes complexes. Niveau intermédiaire.",
    event_type: "meetup", starts_at: 2.weeks.from_now, ends_at: 2.weeks.from_now,
    location: "NUMA, Paris 2e", organizer: "DataParis", online: false,
    external_url: "https://example.com/meetup-sql", subject: subjects["bases-de-donnees"] },
  { title: "Forum des métiers — Numérique & IA",
    description: "Rencontrez des professionnels du numérique. Tables rondes, speed meetings et offres de stage. Gratuit.",
    event_type: "conference", starts_at: 4.weeks.from_now, ends_at: 4.weeks.from_now,
    location: "Palais des Congrès, Paris", organizer: "Pôle Emploi Digital", online: false,
    external_url: "https://example.com/forum-numerique", subject: nil },
].each { |attrs| Event.create!(attrs) }

# ——— CONVERSATIONS ———
# Pas de broadcast Turbo / Solid Cable pendant le seed (évite ArgumentError: No unique index found for id).
Message.suppress_broadcasts = true
begin

conv1 = Conversation.find_or_create_direct!(sender: hugo, recipient: lucas, topic: posts[0].title)
[
  [hugo,  "Salut Lucas ! Mon useEffect part en boucle depuis ce matin, j'arrive pas à m'en sortir.",    2.hours.ago],
  [lucas, "Montre-moi ton code, on va regarder ça ensemble.",                                           110.minutes.ago],
  [hugo,  "useEffect(() => { fetchData(); }, [data]) — fetchData met à jour data à chaque fois.",       100.minutes.ago],
  [lucas, "Voilà le problème ! fetchData modifie data → l'effet se relance → boucle infinie. Utilise [] pour un appel unique au montage.", 90.minutes.ago],
  [hugo,  "Ah oui ! Et si j'ai besoin de relancer sur un vrai changement ?",                            80.minutes.ago],
  [lucas, "Utilise une valeur primitive comme dépendance (un ID, un string), jamais un objet — ils changent de référence à chaque render.", 70.minutes.ago],
  [hugo,  "Super, ça marche maintenant ! Merci beaucoup.",                                              60.minutes.ago],
].each { |u, b, t| Message.create!(conversation: conv1, user: u, body: b, created_at: t, updated_at: t) }
conv1.mark_read_for!(hugo)
conv1.mark_read_for!(lucas)

conv2 = Conversation.find_or_create_direct!(sender: camille, recipient: sofia, topic: posts[3].title)
[
  [camille, "Hey Sofia, mon modèle overfitte grave — 97% train, 63% test.",                   5.hours.ago],
  [sofia,   "Montre-moi ton architecture.",                                                   4.hours.ago],
  [camille, "3 Linear layers : 784→512→256→10. Aucun dropout ni batch norm.",                3.hours.ago],
  [sofia,   "Ajoute nn.Dropout(0.4) entre chaque couche et nn.BatchNorm1d.",                  2.hours.ago],
  [camille, "Je teste ça !",                                                                  1.hour.ago],
  [sofia,   "Dis-moi ce que tu obtiens. N'oublie pas d'augmenter légèrement les epochs aussi.", 50.minutes.ago],
].each { |u, b, t| Message.create!(conversation: conv2, user: u, body: b, created_at: t, updated_at: t) }
conv2.mark_read_for!(camille)
conv2.conversation_participants.find_by!(user: sofia).update!(last_read_at: 2.hours.ago)

conv3 = Conversation.find_or_create_direct!(sender: marie, recipient: lucas, topic: "Méthode pour structurer un projet Rails")
[
  [marie, "Lucas, tu as une bonne structure de départ pour un projet Rails avec auth et API ?",                3.days.ago],
  [lucas, "Devise pour l'auth, jbuilder pour le JSON. Namespace Admin:: pour le back-office.",                  3.days.ago],
  [marie, "Et pour organiser les controllers tu fais comment ?",                                               3.days.ago],
  [lucas, "Namespace tout ce qui est admin dans Admin::, et tout ce qui est API dans Api::V1::.",              3.days.ago],
  [marie, "Parfait merci ! Et pour les tests tu utilises quoi ?",                                             2.days.ago],
  [lucas, "Minitest en Rails par défaut, ou RSpec si tu préfères un DSL plus expressif. J'ai une préférence pour Minitest sur de petits projets.", 2.days.ago],
].each { |u, b, t| Message.create!(conversation: conv3, user: u, body: b, created_at: t, updated_at: t) }
conv3.mark_read_for!(marie)
conv3.mark_read_for!(lucas)

conv4 = Conversation.find_or_create_direct!(sender: romain, recipient: kevin, topic: posts[11].title)
[
  [romain, "Kévin, certbot plante chez moi sur le port 80 — tu aurais une idée ?",                     25.minutes.ago],
  [kevin,  "Oui, Nginx tourne déjà sur le port 80. Arrête-le avant de lancer certbot en mode standalone.", 20.minutes.ago],
  [romain, "`sudo systemctl stop nginx` puis certbot ? Et après je relance Nginx ?",                    15.minutes.ago],
  [kevin,  "Exactement. Ou utilise le plugin Nginx directement : `certbot --nginx -d monsite.com`. Il gère tout automatiquement.", 10.minutes.ago],
  [romain, "Le plugin Nginx a marché ! Merci",                                                          5.minutes.ago],
].each { |u, b, t| Message.create!(conversation: conv4, user: u, body: b, created_at: t, updated_at: t) }
conv4.mark_read_for!(romain)
conv4.mark_read_for!(kevin)

conv5 = Conversation.find_or_create_direct!(sender: lea, recipient: sofia, topic: posts[7].title)
[
  [lea,  "Sofia, mon EXPLAIN montre un Seq Scan même avec des index. Tu as une idée ?",           3.hours.ago],
  [sofia, "Souvent ça vient d'un index non utilisé car les statistiques sont obsolètes. Lance `ANALYZE` sur ta table.", 2.hours.ago],
  [lea,  "J'ai lancé ANALYZE, le planner utilise maintenant l'index ! Mais j'ai toujours une jointure lente.", 1.hour.ago],
  [sofia, "Pour les jointures, vérifie que les colonnes FK ont bien des index. Et essaie d'ajouter LIMIT pour réduire le résultat intermédiaire.", 45.minutes.ago],
].each { |u, b, t| Message.create!(conversation: conv5, user: u, body: b, created_at: t, updated_at: t) }
conv5.mark_read_for!(lea)
conv5.conversation_participants.find_by!(user: sofia).update!(last_read_at: 1.hour.ago)

ensure
  Message.suppress_broadcasts = false
end

# ——— SUBJECT REQUESTS ———

SubjectRequest.create!(user: hugo,   name: "Rust",
  description: "De plus en plus utilisé en système, WebAssembly et embarqué. Peu de ressources en français.",
  status: "pending", created_at: 2.days.ago)
SubjectRequest.create!(user: thomas, name: "Architecture logicielle",
  description: "Clean Architecture, DDD, microservices — sujet transversal que beaucoup de juniors cherchent.",
  status: "pending", created_at: 4.days.ago)
SubjectRequest.create!(user: romain, name: "Reverse Engineering",
  description: "Désassemblage, décompilation, analyse de binaires — essentiel pour les CTF et la sécu offensive.",
  status: "pending", created_at: 1.day.ago)

# ——— RÉSUMÉ ———

puts ""
puts "Seed terminé !"
puts ""
puts "  Comptes demo :"
puts "  ┌──────────────────────────────┬─────────────────┬──────────────────────┐"
puts "  │ Email                        │ Mot de passe    │ Rôle                 │"
puts "  ├──────────────────────────────┼─────────────────┼──────────────────────┤"
puts "  │ admin@studylink.test         │ Admin1234!      │ Admin                │"
puts "  │ lucas@studylink.test         │ Lucas1234!      │ Mentor JS/Rails      │"
puts "  │ sofia@studylink.test         │ Sofia1234!      │ Mentor Python/IA     │"
puts "  │ kevin@studylink.test         │ Kevin1234!      │ Mentor DevOps/Sécu   │"
puts "  │ hugo@studylink.test          │ Hugo1234!       │ Étudiant BTS SIO     │"
puts "  │ camille@studylink.test       │ Camille1234!    │ Étudiante Licence IA │"
puts "  │ thomas@studylink.test        │ Thomas1234!     │ Étudiant Autodidacte │"
puts "  │ marie@studylink.test         │ Marie1234!      │ Étudiante Bootcamp   │"
puts "  │ romain@studylink.test        │ Romain1234!     │ Étudiant Master Sécu │"
puts "  │ lea@studylink.test           │ Lea12345!       │ Étudiante DUT        │"
puts "  └──────────────────────────────┴─────────────────┴──────────────────────┘"
puts ""
puts "  Données :"
puts "  - #{Subject.count} matières  •  #{User.count} utilisateurs (1 admin, 3 mentors, 6 étudiants)"
puts "  - #{Post.count} posts  •  #{Comment.count} commentaires  •  #{Like.count} likes  •  #{Bookmark.count} bookmarks"
puts "  - #{Resource.count} ressources pédagogiques"
puts "  - #{Event.count} événements tech"
puts "  - #{Conversation.count} conversations  •  #{Message.count} messages"
puts "  - #{SubjectRequest.count} demandes de matières"
puts ""
puts "  Comptes existants (hors demo) préservés : #{User.where.not(email: %w[
  admin@studylink.test lucas@studylink.test sofia@studylink.test kevin@studylink.test
  hugo@studylink.test camille@studylink.test thomas@studylink.test marie@studylink.test
  romain@studylink.test lea@studylink.test
]).count}"
