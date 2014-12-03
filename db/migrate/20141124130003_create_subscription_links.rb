class CreateSubscriptionLinks < ActiveRecord::Migration
  def change
    create_table :subscription_links do |t|
      t.integer :subscription_id
      t.integer :link_id
      t.integer :fb_id
      t.string :like_count
      t.string :comment_count

      t.timestamps
    end
  end
end
