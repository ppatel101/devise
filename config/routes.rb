Rails.application.routes.draw do
  get 'reports/index'
  devise_for :users , path_names: {sign_in: "login", sign_out: "logout"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#root to 'home#index'
	resources :reports
		#resources :profiles  
  root 'reports#index'
end
