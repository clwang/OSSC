class PullRequestsController < ApplicationController

  def index
    # We should list the pull requests either both Github and our model
  end

  def show
    # show the individual details of the pull request, we can probably do another api call to get more data

  end

  def new
    # we need the task_id, user_id
    @task = Task.find(params[:task_id])
    @project = @task.project
    setup_github_pull_request
    @pull_request = PullRequest.new
  end

  def create
    #create the pull requests object, also make the pull request via Github API
    # we need to change the status of that todo task to pending request once we create it
    @pull_request = PullRequest.new(params[:pull_request])
    @pull_request.status = "pending"
    @pull_request.save!
    flash[:success] = "Pull request has been created."
    create_github_pull_request
    redirect_to todo_index_path
  end

  def update
    
  end

  private
    def create_github_pull_request
      # figure out the params need to make the pull request
    end

    def setup_github_pull_request
      # we need to get the available forks/branches from the repo
      # get the master branch of the project (project.user.nickname)
      # get the project's name
      # list the branches for the current user
      get_branches_for_repo(current_user.nickname, @project.repo_name)
      @projects_user = @project.user.nickname
    end
end
