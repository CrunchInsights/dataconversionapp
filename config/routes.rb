Rails.application.routes.draw do
  resources :companies do
    collection {post:import}
  end

  get 'welcome/index'
  
  resources :articles 
  root 'welcome#index'
  
  get 'articles/new'
  get 'fileupload/upload'
end
