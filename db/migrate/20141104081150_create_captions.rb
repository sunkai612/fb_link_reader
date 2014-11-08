class CreateCaptions < ActiveRecord::Migration
  def change
    create_table :captions do |t|
      t.integer :category_id
      t.string :root_url

      t.timestamps
    end
  end
end
