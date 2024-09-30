class RenameTypeToRoleInUsersrails < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :type, :role
  end
end
