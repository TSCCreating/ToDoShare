class TodosController < ApplicationController
  before_action :user_check
  
  def index
    path = Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == 'todos' && path[:action] == 'new'
      redirect_back(fallback_location: root_path)
    else
      # render error_template 404
      render plain: '帰れバカ'
    end
  end

  def show
    @todo = Todo.find(params[:id])
    @image = Image.find_by(todo_id: @todo.id)
    # assign_meta_tags(
    #   title: "Super Test",
    #   site: @todo.twitter_id,
    #   image: "https://secure-ridge-55094.herokuapp.com/assets/#{@image.name}",
    #   url: "https://secure-ridge-55094.herokuapp.com/todos/#{@todo.id}"
    # )
  end

  def new
    @todo = Todo.new()
  end

  def create
    @todo = current_user.todos.new(
      first_body: params[:todo][:first_body],
      second_body: params[:todo][:second_body],
      third_body: params[:todo][:third_body],
      twitter_id: current_user.twitter_id,
      likes_count: 0
    )
    if @todo.save
      redirect_to root_path
    else
      render :new
    end
    
    # image = current_user.images.create(
    #   twitter_id: current_user.twitter_id,
    #   todo_id: todo.id,
    #   name: "#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png"
    #   )
    # image.make(
    #   current_user.twitter_id, 
    #   image.name, todo.body, 
    #   current_user.icon_url
    #   )
    # todo.tweet()
    # redirect_to todo_path(todo)

  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    # redirect_to todos_path
  end

  def mypage
    @todos = Todo.where(twitter_id: current_user.twitter_id).order(created_at: 'desc')
  end

  def likes
    likes = Like.where(twitter_id: current_user.twitter_id).order(created_at: 'desc')

    todos_id = []
    likes.each do |like|
      todos_id.push(like.todo_id)
    end

    @todos = []
    todos_id.each do |id|
      @todos.push(Todo.find(id))
    end
  end
end
