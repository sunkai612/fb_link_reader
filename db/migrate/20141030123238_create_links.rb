class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :linking_id
      t.string :linking_type
      t.text :url
      t.text :name
      t.text :fb_created_time
      t.boolean :is_love?
      t.boolean :is_later?

      t.timestamps
    end
  end
end
