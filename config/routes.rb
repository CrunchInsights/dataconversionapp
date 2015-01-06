Rails.application.routes.draw do
  resources :datauploaders do
    collection do
      post :import
      get :showuploadedschema
      get :uploadedfile
      get :uploadfilerecord
      delete :columndelete
    end
  end

  devise_for :users
  get 'welcome/index'
  
root to: 'welcome#index'
end
