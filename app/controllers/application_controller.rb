class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authenticate_user!
	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:username])
#    devise_parameter_sanitizer.permit(:account_update, keys: [:username , :email, :firstname, :lastname, :image])
	def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
  end
end
