module ApplicationHelper
  include Pagy::Frontend

  def safe_external_url(url)
    return if url.blank?

    parsed = URI.parse(url)
    return unless parsed.is_a?(URI::HTTP) && parsed.host.present?

    parsed.to_s
  rescue URI::InvalidURIError
    nil
  end

  def relative_time(timestamp)
    diff = Time.current - timestamp

    case diff
    when 0...60
      "À l'instant"
    when 60...3600
      "Il y a #{(diff / 60).floor} min"
    when 3600...86_400
      "Il y a #{(diff / 3600).floor} h"
    when 86_400...172_800
      "Hier"
    else
      timestamp.strftime("%d/%m/%Y")
    end
  end

  def feed_nav_classes(section)
    base = "nav-btn transition-colors flex items-center gap-2"
    [ base, active_section == section ? "text-white" : "text-gray-400 hover:text-white" ].join(" ")
  end

  def mobile_nav_classes(section)
    [ "flex flex-col items-center gap-1 transition-colors", active_section == section ? "text-primary" : "text-gray-400" ].join(" ")
  end

  def subject_filter_classes(subject, selected_subject)
    if selected_subject == subject
      "w-full text-left px-4 py-3 rounded-xl bg-primary/20 border border-primary/30 text-primary font-medium flex items-center gap-3 transition-all hover:bg-primary/30"
    else
      "w-full text-left px-4 py-3 rounded-xl hover:bg-white/5 text-gray-400 flex items-center gap-3 transition-all"
    end
  end

  def conversation_online?(_user)
    false
  end
end
