class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Must be valid email address' }
  validates_uniqueness_of :email, case_sensitive: false
  has_secure_password

  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties

  before_save :downcase_email

  def downcase_email
    email&.downcase!
  end
end
