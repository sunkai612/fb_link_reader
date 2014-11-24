class CreateUserLinkStatuses < ActiveRecord::Migration
  def change
    create_table :user_link_statuses do |t|
      t.integer :user_id
      t.integer :link_id
      t.string :like_count
      t.string :comment_count
      t.string :share_count
      t.text :publisher
      t.text :publish_id
      t.boolean :is_read?, default: false
      t.boolean :is_page?, default: false
      t.boolean :is_ppl?, default: false
      t.integer :hot_score

      t.timestamps
    end
  end
end
