class RemoveGroupImageFromGroup < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :group_image, :string
  end
end
