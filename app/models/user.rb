class User < ApplicationRecord
  validates :name, :password_digest, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Must be valid email address' }
  has_secure_password

  has_many :user_viewing_parties, dependent: :destroy
  has_many :viewing_parties, through: :user_viewing_parties

  before_save :downcase_email

  def downcase_email
    email&.downcase!
  end

  def hosting
    viewing_parties.where(host_id: id)
  end

  def attending
    viewing_parties.where.not(host_id: id)
  end

  def name_and_email
    "#{name} (#{email})"
  end
end
