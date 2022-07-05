class Bookmark < ApplicationRecord
  validates :movie, presence: true, uniqueness: { scope: :list }
  belongs_to :movie
  belongs_to :list
  belongs_to :user
end
