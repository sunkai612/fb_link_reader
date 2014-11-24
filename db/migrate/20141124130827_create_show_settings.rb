class CreateShowSettings < ActiveRecord::Migration
  def change
    create_table :show_settings do |t|
      t.boolean :show_read?, default: false
      t.integer :show_amount, default: 100
      t.integer :load_amount, default: 100

      t.timestamps
    end
  end
end
