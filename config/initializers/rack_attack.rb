class Rack::Attack
  # Autorise les requêtes localhost en dev
  safelist("allow-localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1"
  end

  # Connexion : 10 tentatives / 20 secondes par IP
  throttle("logins/ip", limit: 10, period: 20) do |req|
    req.ip if req.path == "/users/sign_in" && req.post?
  end

  # Inscription : 5 comptes / 1 heure par IP
  throttle("signups/ip", limit: 5, period: 1.hour) do |req|
    req.ip if req.path == "/users" && req.post?
  end

  # Création de posts : 20 / 10 minutes par IP
  throttle("posts/ip", limit: 20, period: 10.minutes) do |req|
    req.ip if req.path == "/posts" && req.post?
  end

  # Envoi de messages : 30 / 1 minute par IP
  throttle("messages/ip", limit: 30, period: 1.minute) do |req|
    req.ip if req.path.match?(%r{/messages/\d+/messages}) && req.post?
  end

  # Création de commentaires : 30 / 10 minutes par IP
  throttle("comments/ip", limit: 30, period: 10.minutes) do |req|
    req.ip if req.path == "/comments" && req.post?
  end

  # Suggestion de tags IA : 20 / 1 minute par IP (appel API Claude)
  throttle("ai_tags/ip", limit: 20, period: 1.minute) do |req|
    req.ip if req.path == "/posts/suggest_tags" && req.post?
  end

  # Réponse 429 en JSON ou HTML
  self.throttled_responder = lambda do |req|
    match_data = req.env["rack.attack.match_data"]
    retry_after = match_data ? (match_data[:period] - (Time.now.to_i % match_data[:period])) : 60

    if req.env["HTTP_ACCEPT"]&.include?("application/json")
      [ 429, { "Content-Type" => "application/json", "Retry-After" => retry_after.to_s },
        [ { error: "Trop de requêtes. Réessayez dans #{retry_after} secondes." }.to_json ] ]
    else
      [ 429, { "Content-Type" => "text/html", "Retry-After" => retry_after.to_s },
        [ "<h1>Trop de requêtes</h1><p>Réessayez dans #{retry_after} secondes.</p>" ] ]
    end
  end
end

# Rack::Attack utilise Rails.cache par défaut. En production, Rails.cache est Solid Cache
# (base PostgreSQL séparée, table solid_cache_entries). Si cette base n'est pas migrée ou
# absente, le throttle sur POST /users/sign_in lève une erreur avant Devise.
# Les compteurs de rate limiting utilisent donc un store dédié (pas le fragment cache app).
Rack::Attack.cache.store =
  if Rails.env.local?
    ActiveSupport::Cache::MemoryStore.new
  else
    ActiveSupport::Cache::FileStore.new(
      Rails.root.join("tmp/cache/rack_attack"),
      expires_in: 2.days
    )
  end
