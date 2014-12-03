class RenameTypeInSubscription < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :type, :fb_type
  end
end
