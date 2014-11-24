class AddUpdateTimeColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :collection_update, :datetime
    add_column :users, :subscribed_page_update, :datetime
    add_column :users, :subscribed_ppl_update, :datetime
  end
end
