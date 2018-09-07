Rails.application.routes.draw do
  
  # get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')
  # get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'reports/index'
  devise_for :users , path_names: {sign_in: "login", sign_out: "logout"}, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
#root to 'home#index'
	resources :reports
		#resources :profiles  
  root 'reports#index'
end
