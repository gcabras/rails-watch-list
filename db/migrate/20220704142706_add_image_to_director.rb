class AddImageToDirector < ActiveRecord::Migration[6.1]
  def change
    add_column :directors, :image, :text
  end
end
