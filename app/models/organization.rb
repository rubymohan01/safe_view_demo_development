class Organization < ApplicationRecord
	attr_accessor :admin_user_ids

  has_many :channels, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_one :policy, dependent: :destroy
  accepts_nested_attributes_for :policy

  enum status: { pending: 0, active: 1, inactive: 2 }

   # validate :must_have_at_least_one_admin
  validates :name, presence: true

  private

  def must_have_at_least_one_admin
    if memberships.select { |m| m.admin? || m.super_admin? }.empty?
      errors.add(:base, "Organization must have at least one admin")
    end
  end
end
