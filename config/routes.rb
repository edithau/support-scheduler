Nr3::Application.routes.draw do
  resources :users, only: [:index, :create, :show, :destroy]
  resources :assignments, only: [:index, :create, :update, :show]

  post 'assignments/swap_user/:id1/:id2', :to => 'assignments#swap_user'
  post 'assignments/:id/replace_user/:replacement_user_id', :to=> 'assignments#replace_user'

  get 'users/:id/assignments', :to => 'users#assignments'
  post 'users', :to => 'users#create', :as => 'user'

end
