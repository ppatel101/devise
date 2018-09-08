class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def all
    
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted? 
      session[:user_id] = user.id
      sign_in_and_redirect user, notice: "Signed in!"
    else
      # Devise allow us to save the attributes eventhough 
      # we havent create the user account yet
      session["devise.user_attributes"] = user.attributes
      # Because Twitter doesn't provide user's email, it would be nice if we force user to enter it
      # manually on the registration page before we create their account.
      # Here we pass the callback parameter so that we could use it to edit the registration page.
      redirect_to new_user_registration_url(:callback => "twitter")
    end
  end
  
  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :linkedin, :all
  alias_method :github, :all
  alias_method :google_oauth2, :all
end
  #======================================= 
  #       linkedin        
  #=======================================     
  # def self.provides_callback_for(provider)
  #   class_eval %Q{
  #     def #{provider}
  #       @user = User.find_for_oauth(env["omniauth.auth"], current_user)

  #       if @user.persisted?
  #         sign_in_and_redirect @user, event: :authentication
  #         set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  #       else
  #         session["devise.#{provider}_data"] = env["omniauth.auth"]
  #         redirect_to new_user_registration_url
  #       end
  #     end
  #   }
  # end

  # [:twitter, :facebook, :linked_in].each do |provider|
  #   provides_callback_for provider
  # end

  # def after_sign_in_path_for(resource)
  #   if resource.email_verified?
  #     super resource
  #   else
  #     finish_signup_path(resource)
  #   end
  # end

  #======================================= 
  #       google        
  #=======================================     
#   def google_oauth2
#     # You need to implement the method below in your model (e.g. app/models/user.rb)
    
#     @user = User.from_omniauth(request.env['omniauth.auth'])

#     if @user.persisted?
#       flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
#       sign_in_and_redirect @user, event: :authentication
#     else
#       session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
#       redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
#     end
#   end
# end
  #======================================= 
  #       linkedin        
  #=======================================     
 # def all
 #    @user = User.from_omniauth(request.env["omniauth.auth"])

 #    if @user.persisted?
 #      sign_in_and_redirect root_path, :event => :authentication #this will throw if @user is not activated
 #      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
 #    else
 #      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
 #      flash[:notice] = flash[:notice].to_a.concat resource.errors.full_messages
 #      redirect_to new_user_registration_url
 #    end
 #  end

 #  alias_method :twitter, :all

 #  def failure
 #    redirect_to root_path
 #  end