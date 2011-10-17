class TodoController < ApplicationController

  def index
    @tasks = current_user.tasks
    Rails.logger.info @tasks.inspect
  end

  def show
    @task = Todo.find(params[:id])
  end

  def create
    # create the todo task
    # add the current_user.id and the task_id
    # add the status as current, we will need to list only tasks that are open on the projects/tasks list page
    @todo = Todo.create(:user_id => current_user.id, :task_id => params[:task_id], :status => "open" )
    flash[:success] = "Successfully added the task"
    redirect_to todo_index_path()
  end

end
