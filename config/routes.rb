Rails.application.routes.draw do
  
  #get 'users/finish_signup'
  # get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')
  # get 'signout', to: 'sessions#destroy', as: 'signout'
 # get 'reports/index'
  #devise_for :users , path_names: {sign_in: "login", sign_out: "logout"}, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
	resources :reports
		#resources :profiles 

  devise_for :users , path_names: {sign_in: "login", sign_out: "logout"}, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  as :user do
     get 'login' => 'sessions#new', :as => "login"
     get 'signup' => 'registrations#new', :as => "signup"  
     get 'signout' => 'devise/sessions#destroy', :as => "signout"
  end   
  root 'reports#index'
end
