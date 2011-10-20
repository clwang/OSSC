class TodoController < ApplicationController

  def index
    # we need to refactor the queries with active record later on
    @open_todos = current_user.todos.where(:status => 'open')
    @open_tasks = Task.where( :id => @open_todos.map(&:task_id) )
    @pending_todos = current_user.todos.where(:status => 'pending')
    @pending_tasks = Task.where( :id => @pending_todos.map(&:task_id) )
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
