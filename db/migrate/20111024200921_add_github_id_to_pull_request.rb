class AddGithubIdToPullRequest < ActiveRecord::Migration
  def change
    add_column :pull_requests, :github_id, :integer
  end
end
