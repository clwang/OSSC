class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def after_sign_in_path_for(resource)
      stored_location_for(resource) || '/dashboard'
  end

  def get_repo_list
    create_git_instance
    @repo_names = []
    @git.repos.list_repos.each do | repo |
      option = [repo.name,repo.name]
      @repo_names.push(option)
    end
  end

  def get_branches_for_repo(user_name, repo_name)
    # needs to have the 'user-name' and 'repo-name' as params
    create_git_instance
    @branches = []
    @git.repos.branches(user_name,repo_name).each do | branch |
      option = [branch.name,branch.name]
      @branches.push(option)
    end
  end

  def create_git_instance
    token = current_user.user_oauth_tokens.first.access_token
    @git = Github.new(:oauth_token => token)
  end
   
end
