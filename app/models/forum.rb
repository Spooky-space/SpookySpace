class Forum < ApplicationRecord
  validates :comment, :tmdb_api_id, :username, :user_id, presence: true
  validates :comment, length: { minimum:10 }
  belongs_to :user
end
