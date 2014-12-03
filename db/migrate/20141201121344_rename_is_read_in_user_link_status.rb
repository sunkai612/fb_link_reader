class RenameIsReadInUserLinkStatus < ActiveRecord::Migration
  def change
    rename_column :user_link_statuses, :is_read?, :read
  end
end
