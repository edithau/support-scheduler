Nr3::Application.routes.draw do
  resources :heroes, only: [:index, :create, :show, :destroy]
  resources :assignments, only: [:index, :create, :update, :show]

  post 'assignments/:id', :to => 'assignments#update'

  get 'heroes/:id/assignments', :to => 'heroes#assignments', :as => 'assignment'
  post 'heroes', :to => 'heroes#create', :as => 'hero'

end
