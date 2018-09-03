class TodosController < ApplicationController
  before_action :user_check
  def index
    @todos = Todo.all.order(created_at: 'desc').limit(5)
  end

  def timeline
    @todos = Todo.all.order(created_at: 'desc').limit(5)
  end

  def show
    @todo = Todo.find(params[:id])
    @image = Image.find_by(todo_id: @todo.id)
    assign_meta_tags(
      title: "Super Test",
      site: @todo.twitter_id,
      image: "https://secure-ridge-55094.herokuapp.com/assets/#{@image.name}",
      url: "https://secure-ridge-55094.herokuapp.com/todos/#{@todo.id}"
    )
  end

  def create
    todo = current_user.todos.create(
      body: params[:post][:body],
      twitter_id: current_user.twitter_id,
      likes_count: 0
    )
    image = current_user.images.create(
      twitter_id: current_user.twitter_id,
      todo_id: todo.id,
      name: "#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png"
    )
    image.make(current_user.twitter_id,image.name,todo.body,current_user.icon_url)
    # todo.tweet()
    redirect_to todo_path(todo)
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    redirect_to todos_path
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
