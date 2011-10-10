class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project, :except => :show
  
  def new
    @task = @project.tasks.build
  end
  
  def create
    @task = Task.new(params[:task])
    @task.project_id = params[:project_id]
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
