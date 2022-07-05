class AddImageTitleToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :imageonetitle, :text
    add_column :movies, :imagetwotitle, :text
    add_column :movies, :imagethreetitle, :text
  end
end
