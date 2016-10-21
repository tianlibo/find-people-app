class AddCrumbsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :crumbs_count, :integer, default: 0
  end
end
