class CreateParentalConsents < ActiveRecord::Migration[7.1]
  def change
    create_table :parental_consents do |t|
      t.references :minor_user, null: false, foreign_key: { to_table: :users }
      t.references :guardian_user, null: false, foreign_key: { to_table: :users }
      t.string :status

      t.timestamps
    end
  end
end
