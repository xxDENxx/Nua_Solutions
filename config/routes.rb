Rails.application.routes.draw do

  root :to => 'messages#index'

  resources :messages do
    get :reissue, on: :member
  end
end
