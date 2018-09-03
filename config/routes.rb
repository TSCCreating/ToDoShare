Rails.application.routes.draw do
  resources :todos, only: [:create, :destroy, :new, :show] do
    resources :likes, only: [:create, :destroy]
  end
  get '/timeline' => 'todos#timeline'
  get '/top' => 'static_pages#top'
  get '/:twitter_id' =>  'todos#mypage'
  get '/:twitter_id/likes' => 'todos#likes'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  root 'static_pages#top'
end
