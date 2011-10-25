class PullRequestsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    # We should list the pull requests either both Github and our model
    # We need to get the list of repos that the user has, and also get the user's github nickname
    # need to sync the data with the github id
    @user_name = current_user.nickname
    @repo_list = current_user.projects.where("repo_name IS NOT NULL").map(&:repo_name)
    list_github_pull_requests
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
    # need to set the todo status to pending

    @pull_request = PullRequest.new(params[:pull_request])
    @pull_request.status = "open"
    @pull_request.save!

    @todo = Todo.where(:task_id => params[:pull_request][:task_id], :user_id => current_user.id).first
    @todo.status = "pending"
    @todo.save!

    flash[:notice] = "Pull request has been created."

    @prepared_head = "#{current_user.nickname}:#{params[:pull_request][:head]}"
    create_github_pull_request

    redirect_to todo_index_path
  end

  def merge
    # we need to merge or deny
    # then we change the status of the tasks
    # then assign the points of that task to the user
    @pull_request = PullRequest.where(:github_id => params[:id]).first
    merge_github_pull_request

    @pull_request.status = "closed"
    @pull_request.save!

    @task = Task.find(@pull_request.task_id)
    @task.status = "closed"
    @task.save!

    @todo = Todo.where(:user_id => @pull_request.user_id, :task_id => @pull_request.task_id).first
    @todo.status = "closed"
    @todo.save!

    @user = User.find(@pull_request.user_id)
    user_points = @user.rank.user_points
    @user.rank.user_points = user_points + @task.point_value
    @user.rank.save!

    flash[:notice] = "Pull request has been merged"

    redirect_to pull_requests_path()
  end

  def deny
    # there is not api call to deny the pull request, so we will deny just in our system and the user has to manually delete the request
    @pull_request = PullRequest.where(:github_id => params[:id]).first
    @pull_request.status = "closed"

    @task = Task.find(@pull_request.task_id)
    @task.status = "closed"
    @task.save!

    @todo = Todo.where(:user_id => @pull_request.user_id, :task_id => @pull_request.task_id).first
    @todo.status = "closed"
    @todo.save!

    flash[:notice] = "Pull request has been denied"

    redirect_to pull_requests_path()
  end

  def update
    
  end

  private

  def merge_github_pull_request
    #  @github.pull_requests.merge 'user-name', 'repo-name', 'request-id'
    create_github_instance
    @git.pull_requests.merge current_user.nickname, @pull_request.repo_name, 1
  end

  def sync_github_pull_requests
    @repo_pulls.each do | k,v |
      pull_request = PullRequest.where(:title => v.first.title).first
      Rails.logger.info pull_request.inspect
      unless pull_request.nil?
        pull_request.github_id = v.first.id
        pull_request.save!
      end
    end
  end
  
  def list_github_pull_requests
    #  @pull_reqs = Github::PullRequests.new
    #  @pull_reqs.pull_requests 'user-name', 'repo-name'
    create_github_instance
    @repo_pulls = {}
    # loop through each repo and get the list of pull requests
    @repo_list.each do | repo |
      @repo_pulls[repo.to_sym] = @git.pull_requests.pull_requests @user_name, repo
    end
    Rails.logger.info @repo_pulls.inspect
    #sync_github_pull_requests
  end

  def create_github_pull_request
    #  @github.pull_requests.create_request 'user-name', 'repo-name',
    #    "title" => "Amazing new feature",
    #    "body" => "Please pull this in!",
    #    "head" => "octocat:new-feature",
    #    "base" => "master"
    create_github_instance
    @git.pull_requests.create_request current_user.nickname, params[:pull_request][:repo_name],
      "title" => params[:pull_request][:title],
      "body" => params[:pull_request][:body],
      "head" => @prepared_head,
      "base" => params[:pull_request][:base]
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
