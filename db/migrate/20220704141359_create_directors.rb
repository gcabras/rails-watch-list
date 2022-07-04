class CreateDirectors < ActiveRecord::Migration[6.1]
  def change
    create_table :directors do |t|
      t.string :name
      t.text :summary
      t.date :birthdate
      t.date :deathdate
      t.text :awards

      t.timestamps
    end
  end
end
