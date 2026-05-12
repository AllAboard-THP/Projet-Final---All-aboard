class User < ApplicationRecord
  enum :role, { user: "user", admin: "admin" }

  has_one_attached :avatar_image

  has_many :posts, dependent: :destroy
  has_many :mentor_subjects, dependent: :destroy
  has_many :competences, through: :mentor_subjects, source: :subject
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants
  has_many :subject_requests, dependent: :destroy
  has_many :resources, dependent: :destroy

  VALID_EMAIL_REGEX    = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
  AVATAR_CONTENT_TYPES = %w[image/jpeg image/png image/webp].freeze

  validate :avatar_image_valid, if: -> { avatar_image.attached? && avatar_image.changed? }
  PASSWORD_REGEX    = /\A(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).+\z/

  validates :full_name, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX, message: "n'est pas une adresse valide" }
  validates :password, format: {
    with: PASSWORD_REGEX,
    message: "doit contenir au moins une majuscule, un chiffre et un caractère spécial"
  }, if: :password_required?

  before_validation :populate_full_name, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # :confirmable — à activer avec SMTP Brevo

  def display_name
    full_name.presence || email.split("@").first.titleize
  end

  def profile_avatar
    if avatar_image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(avatar_image, only_path: true)
    elsif avatar_url.present?
      avatar_url
    else
      "https://ui-avatars.com/api/?background=6366f1&color=ffffff&name=#{ERB::Util.url_encode(display_name)}"
    end
  end

  def initials
    display_name.split.map { |part| part.first }.join.first(2).upcase
  end

  def contribution_count
    comments.size + messages.size
  end

  def unread_messages_count
    conversation_participants.includes(:conversation).sum do |participant|
      participant.conversation.unread_count_for(self)
    end
  end

  private

  def populate_full_name
    self.full_name = email.split("@").first.titleize if full_name.blank? && email.present?
  end

  def avatar_image_valid
    unless AVATAR_CONTENT_TYPES.include?(avatar_image.content_type)
      errors.add(:avatar_image, "doit être une image JPG, PNG ou WebP")
    end
    if avatar_image.byte_size > 2.megabytes
      errors.add(:avatar_image, "ne doit pas dépasser 2 Mo")
    end
  end
end
