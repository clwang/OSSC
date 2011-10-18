class PullRequestsController < ApplicationController

  def index
    # We should list the pull requests either both Github and our model
  end

  def show

  end

  def new
    # we need the task_id, user_id, 
    @pull_request = PullRequest.new
  end

  def create
    #create the pull requests object, also make the pull request via Github API
    create_github_pull_request
  end

  def update
    
  end

  private
    def create_github_pull_request

    end
end
