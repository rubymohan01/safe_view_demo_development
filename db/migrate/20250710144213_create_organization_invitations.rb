class CreateOrganizationInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_invitations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.references :organization, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :accepted, default: false

      t.timestamps
    end

    add_index :organization_invitations, :token, unique: true
  end
end
