Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :todos, only: [:create, :update, :destroy] do
    member do
      post :toggle
    end
    collection do
      post :toggle_all
      get :active
      get :completed
      delete :destroy_completed
    end
  end
  root 'todos#index'
end
