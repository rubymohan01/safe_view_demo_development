class OrganizationInvitation < ApplicationRecord
  belongs_to :organization
  belongs_to :user, optional: true

  before_create :generate_token

  validates :email, presence: true
  validates :email, uniqueness: { scope: :organization_id, message: "has already been invited to this organization" }

  private

  def generate_token
    self.token = SecureRandom.hex(16)
  end
end
