class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.string :status
      t.string :title
      t.string :repo_name
      t.string :body
      t.string :base
      t.string :head
      t.integer :user_id
      t.integer :task_id
      t.integer :project_id
      t.timestamps
    end
  end
end
