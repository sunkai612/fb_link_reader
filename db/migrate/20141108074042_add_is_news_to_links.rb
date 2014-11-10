class AddIsNewsToLinks < ActiveRecord::Migration
  def change
    add_column :links, :is_news?, :boolean
  end
end
