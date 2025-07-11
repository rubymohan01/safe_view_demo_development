class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  enum role: { viewer: 0, editor: 1, admin: 2 }

  def organization_admin?(org)
    memberships.find_by(organization: org)&.admin?
  end
end
