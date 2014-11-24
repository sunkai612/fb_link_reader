class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :fb_id
      t.string :name
      t.text :url
      t.datetime :fb_created_time
      t.boolean :is_read?

      t.timestamps
    end
  end
end
