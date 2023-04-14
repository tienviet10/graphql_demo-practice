class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :name
      t.text :description
      t.text :imageURL
      t.datetime :releaseDate
      t.decimal :avg_score, precision: 3, scale: 1
      t.integer :total_ratings

      t.timestamps
    end
  end
end
