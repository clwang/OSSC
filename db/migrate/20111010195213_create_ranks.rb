class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :user_id
      t.string :ranking
      t.integer :user_points
      t.timestamps
    end
  end
end
