class CreateListAdds < ActiveRecord::Migration[7.1]
  def change
    create_table :list_adds do |t|
      t.integer :tmdb_api_id
      t.boolean :watched
      t.integer :rating
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
