class Channel < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :name, presence: true
end
