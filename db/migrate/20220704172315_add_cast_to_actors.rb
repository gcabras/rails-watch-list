class AddCastToActors < ActiveRecord::Migration[6.1]
  def change
    add_reference :actors, :cast, null: false, foreign_key: true
  end
end
