class Movie < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :overview, presence: true
  has_many :bookmarks
  before_destroy :check_for_bookmark

  belongs_to :director
  has_one :cast
  has_many :actors, through: :cast

  private

  def check_for_bookmark
    if bookmarks.count.positive?
      errors.add("Cannot destroy the movie, it has #{bookmarks.count} bookmarks!")
      false
    end
  end
end
