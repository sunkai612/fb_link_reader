class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :fb_id
      t.string :fb_name
      t.string :type
      t.integer :belonged_links, defalut: 0

      t.timestamps
    end
  end
end
