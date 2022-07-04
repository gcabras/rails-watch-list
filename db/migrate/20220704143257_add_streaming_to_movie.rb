class AddStreamingToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :streaming, :text
  end
end
