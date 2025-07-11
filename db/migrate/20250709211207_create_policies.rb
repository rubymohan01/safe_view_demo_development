class CreatePolicies < ActiveRecord::Migration[7.1]
  def change
    create_table :policies do |t|
      t.references :organization, null: false, foreign_key: true
      t.integer :min_age
      t.boolean :parental_consent_required

      t.timestamps
    end
  end
end
