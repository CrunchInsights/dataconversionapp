Rails.application.routes.draw do
  resources :datauploaders do
    collection {post:import}
  end

  devise_for :users
  get 'welcome/index'
  
root to: 'welcome#index'
end
