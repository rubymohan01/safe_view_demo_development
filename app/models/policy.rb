class Policy < ApplicationRecord
  belongs_to :organization

  validates :min_age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end