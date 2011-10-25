class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project, :except => :show
  
  def index
    @tasks = @project.tasks.where(:status => "open")
  end
  
  def new
    @task = @project.tasks.build
  end
  
  def create
    @task = @project.tasks.build(params[:task].merge!(:user => current_user))
    @task.status = "open"
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Project was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  private
    def find_project
      @project = Project.find(params[:project_id])
    end
end
