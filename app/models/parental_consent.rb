class ParentalConsent < ApplicationRecord
  belongs_to :minor_user, class_name: "User"
  belongs_to :guardian_user, class_name: "User"

  validates :minor_user_id, uniqueness: { scope: :guardian_user_id }
end
