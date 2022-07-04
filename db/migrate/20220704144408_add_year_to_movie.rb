class AddYearToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :year, :integer
  end
end
