class RemoveColumnsFromLinks < ActiveRecord::Migration
  def change
    remove_column :links, :linking_id, :integer
    remove_column :links, :linking_type, :string
    remove_column :links, :is_love?, :boolean
    remove_column :links, :is_later?, :boolean
    remove_column :links, :is_news?, :boolean
  end
end
