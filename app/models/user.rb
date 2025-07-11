class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :organizations, through: :memberships
  has_many :channels
  enum role: { user: 0, admin: 1, super_admin: 2 }
  after_create :set_role

  def set_role
    self.update(role: :user) if !self.role.present?
  end
  def age
    return unless date_of_birth
    now = Time.zone.today
    now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end

  def is_org_admin?
   admin? || super_admin?
  end
end
