Nr3::Application.routes.draw do
  resources :users, only: [:index, :create, :show, :destroy]
  resources :assignments, only: [:index, :create, :update, :show]

  post 'assignments/:id', :to => 'assignments#update'

  get 'users/:id/assignments', :to => 'users#assignments' #, :as => 'assignment'
  post 'users', :to => 'users#create', :as => 'user'

end
