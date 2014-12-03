class ChangeFbCreatedTimeFromLinks < ActiveRecord::Migration
  def change
    change_column :links, :fb_created_time, :datetime
  end
end
