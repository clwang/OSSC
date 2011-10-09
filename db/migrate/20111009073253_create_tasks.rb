class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :description
      t.integer :point_value
      t.string :status
      t.integer :project_id
      t.timestamps
    end
  end
end
