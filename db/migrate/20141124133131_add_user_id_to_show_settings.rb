class AddUserIdToShowSettings < ActiveRecord::Migration
  def change
    add_column :show_settings, :user_id, :integer
  end
end
