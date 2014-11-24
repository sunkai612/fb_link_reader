class CreateSubscribedObjs < ActiveRecord::Migration
  def change
    create_table :subscribed_objs do |t|
      t.integer :user_id
      t.integer :subscription_id

      t.timestamps
    end
  end
end
