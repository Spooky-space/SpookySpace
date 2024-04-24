class CreateForums < ActiveRecord::Migration[7.1]
  def change
    create_table :forums do |t|
      t.integer :tmdb_api_id
      t.string :username
      t.text :comment
      t.bigint :user_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
