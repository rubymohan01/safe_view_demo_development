class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.references :channel, null: false, foreign_key: true
      t.integer :min_age
      t.integer :visibility
      t.string :youtube_url

      t.timestamps
    end
  end
end
