class ViewingParty < ApplicationRecord
  validates :movie_title, :movie_id, :host_id, :date, :start_time, :poster_path, presence: true
  validates :duration, presence: true, numericality: true

  belongs_to :host, class_name: 'User'
  has_many :user_viewing_parties, dependent: :destroy
  has_many :users, through: :user_viewing_parties

  def attendees
    users.select(:name).where.not(id: host.id).pluck(:name).to_sentence
  end
end
