class AddRoleToActor < ActiveRecord::Migration[6.1]
  def change
    add_column :actors, :role, :string
  end
end
