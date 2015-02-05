Rails.application.routes.draw do
  resources :datauploaders, :controller => 'data_uploaders', only: [:file_upload, :import, :changetablecolumndetail,
                                                                    :showuploadedschema, :uploadedfile, :uploadfilerecord,
                                                                    :columnexcludeinclude] do
    collection do
      get :fileupload, :action => 'file_upload'
      post :import
      post :fileuploadtoamazon, :action=>'file_upload_to_amazon'
      post :changetablecolumndetail, :action=>'change_table_column_detail'
      get :showuploadedschema, :action => 'show_uploaded_schema'
      get :uploadedfile, :action => 'uploaded_file'
      get :uploadfilerecord, :action=>'upload_file_record'
      post :uploadfilerecord, :action=>'upload_file_record'
      delete :columnexcludeinclude, :action=>'column_exclude_include'
      delete :deleteuserfilemappingrecord, :action=>'delete_user_file_mapping_record'
      post :uploadfilecolumnsforrecord, :action=>'upload_file_columns_for_record'
    end
  end

  resources :recordtrends, :controller => 'trend_analysis', only: [:simple_trend] do
    collection do
      get :simpletrend , :action => 'simple_trend'
    end
  end
  devise_for :users
  root to: 'welcome#welcome'
end
