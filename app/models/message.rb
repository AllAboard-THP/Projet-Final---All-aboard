class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  # Désactivé pendant db:seed (broadcast_append_to / Solid Cable → upsert sans index unique fiable).
  class_attribute :suppress_broadcasts, default: false

  belongs_to :conversation, touch: true
  belongs_to :user

  has_one_attached :attachment

  validates :body, presence: true, unless: -> { attachment.attached? }

  after_create_commit :broadcast_to_conversation, unless: -> { suppress_broadcasts }

  def as_chat_json
    {
      id:         id,
      body:       body,
      user_id:    user_id,
      user_name:  user.display_name,
      avatar_url: user.profile_avatar,
      created_at: created_at.iso8601,
      type:       "message"
    }
  end

  private

  def broadcast_to_conversation
    # Broadcast JSON vers le channel React
    ConversationChannel.broadcast_to(conversation, as_chat_json)

    # Garde le Turbo Stream pour les clients non-React (fallback)
    conversation.users.where.not(id: user_id).each do |recipient|
      broadcast_append_to(
        [ conversation, recipient ],
        target: "#{dom_id(conversation)}_messages",
        partial: "messages/message",
        locals: { message: self }
      )
    end
  end
end
