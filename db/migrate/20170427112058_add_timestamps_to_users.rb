class AddTimestampsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:users, null: true)
  end
end
