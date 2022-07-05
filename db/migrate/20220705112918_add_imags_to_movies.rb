class AddImagsToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :imageone, :text
    add_column :movies, :imagetwo, :text
    add_column :movies, :imagethree, :text
  end
end
