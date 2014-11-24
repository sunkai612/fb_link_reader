class DropCaptionsTable < ActiveRecord::Migration
  def change
    drop_table :captions
  end
end
