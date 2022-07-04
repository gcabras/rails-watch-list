class CreateActors < ActiveRecord::Migration[6.1]
  def change
    create_table :actors do |t|
      t.string :name
      t.text :summary
      t.date :birthdate
      t.date :deathdate
      t.text :awards
      t.text :image

      t.timestamps
    end
  end
end
