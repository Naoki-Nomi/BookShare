class RemoveUserIdFromContacts < ActiveRecord::Migration[5.2]
  def up
    remove_column :contacts, :user_id
  end

  def down
    add_column :contacts, :user_id, :integer
  end
end
