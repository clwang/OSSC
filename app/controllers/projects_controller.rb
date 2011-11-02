class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    get_repo_list
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    get_repo_list
  end

  # POST /projects
  # POST /projects.json
  def create
    Rails.logger.info params[:project]
    @project = Project.new(params[:project])
    # if it is a current github project then we do not need to create it on github
    if params[:project][:repo_name].blank?
      @project.repo_name = params[:project][:name]
    end
    @project.user_id = current_user.id
    respond_to do |format|
      if @project.save
        create_github_project
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        get_repo_list
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :ok }
    end
  end
  
  def my_projects
    if current_user
      @projects = current_user.projects
    else
      @projects = nil
    end
  end
  
  private
  
  def create_github_project
    create_github_instance
    #   @github.repos.create_repo :name => 'repo-name', :org => 'organisation-name'
    @git.repos.create_repo :name => @project.name, :description => params[:project][:description]      
  end    
end
