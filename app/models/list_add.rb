class ListAdd < ApplicationRecord
  validates :rating, :watched, :tmdb_api_id, presence: true
  validates :rating, inclusion: { in: 0..5 }, allow_nil: true
  validates :watched, inclusion: [true, false]
  validates :watched, exclusion: [nil]
  belongs_to :user
end
