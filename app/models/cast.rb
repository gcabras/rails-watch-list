class Cast < ApplicationRecord
  belongs_to :movie
  has_many :actors
end
