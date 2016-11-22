class AddAnalyticsUuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :analytics_uuid, :string
  end
end
