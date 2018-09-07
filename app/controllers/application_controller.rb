class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!
	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:username])
#    devise_parameter_sanitizer.permit(:account_update, keys: [:username , :email, :firstname, :lastname, :image])
  end
end
