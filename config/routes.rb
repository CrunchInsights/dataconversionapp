Rails.application.routes.draw do
  devise_for :users
  resources :companies do
    collection {post:import}
  end
  get 'welcome/index'
  resources :articles  
  get 'articles/new'
  get 'fileupload/upload'
  
root to: 'welcome#index'
end
