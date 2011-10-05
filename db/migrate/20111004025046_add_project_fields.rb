class AddProjectFields < ActiveRecord::Migration
  def change
    add_column :projects, :status, :string
    add_column :projects, :description, :text
    add_column :projects, :total_points, :integer
    add_column :projects, :us_user_id, :integer
  end
end