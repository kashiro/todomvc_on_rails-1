class TodosController < ApplicationController
  helper_method :current_filter

  def index
    @todos = Todo
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.save
    render 'todos/create.js.erb', format: :js
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.update(todo_params)
    render 'todos/update.js.erb', format: :js
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    render 'todos/destroy.js.erb', format: :js
  end

  def toggle
    @todo = Todo.find(params[:id])
    @todo.toggle!(:completed)
    render 'todos/toggle.js.erb', format: :js
  end

  def toggle_all
    Todo.update_all(completed: params[:completed] ? true : false)
    @todos = Todo.all
    render 'todos/toggle_all.js.erb', format: :js
  end

  def active
    @todos = Todo.active
    set_current_filter(:active)
    render :index
  end

  def completed
    @todos = Todo.completed
    set_current_filter(:completed)
    render :index
  end

  def destroy_completed
    # from Rails 3 where statement became azy evaluation
    # To refer deleted todos we call `to_a` to evaluate completed scope immediately.
    @todos_for_destruction = Todo.completed.to_a
    Todo.completed.destroy_all
    render 'todos/destroy_completed.js.erb', format: :js
  end

  private
    def todo_params
      params.require(:todo).permit(:title, :completed)
    end

    def set_current_filter(filter)
      @current_filter = filter
    end

    def current_filter
      @current_filter
    end
end
