MileageTracker::Application.routes.draw do

	devise_for :users, :skip => [:sessions]

	as :user do
		get 'login' => 'devise/sessions#new', :as => :new_user_session
		post 'login' => 'devise/sessions#create', :as => :user_session
		delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
	end

  get 'download' => 'mileage_records#download', as: :download_data
  post 'download/month' => 'mileage_records#download_month'

  resources :mileage_records, :path => "" do
		collection do
			get 'list-view' => 'mileage_records#list_view'
			get 'stats' => 'mileage_records#stats'
		end
	end

  root 'mileage_records#index'

end
