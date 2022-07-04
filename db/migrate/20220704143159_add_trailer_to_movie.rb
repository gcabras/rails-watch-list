class AddTrailerToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :trailer, :text
  end
end
