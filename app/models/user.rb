  class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable, :omniauthable
         #, omniauth_providers: [:google_oauth2, :linkedin]
def self.from_omniauth(auth, signed_in_resource = nil)
  user = User.where(provider: auth.provider, uid: auth.uid).first
  if user.present?
    user
  else
    # Check wether theres is already a user with the same 
    # email address
    user_with_email = User.find_by_email(auth.info.email)
    if user_with_email.present?
      user = user_with_email
    else
        user = User.new
        if auth.provider == "facebook"
        
          user.provider = auth.provider
          user.uid = auth.uid
          #user.oauth_token = auth.credentials.token
          #user.firstname = auth.firstname
          #user.firstname = auth.extra.raw_info.firstname
          #user.last_name = auth.extra.raw_info.last_name
          user.email = auth.extra.raw_info.email
          # Facebook's token doesn't last forever
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save
      
      elsif auth.provider == "linkedin" 
      
        user.provider = auth.provider
        user.uid = auth.uid
          #user.oauth_token = auth.credentials.token
          
          #user.first_name = auth.info.first_name
          #user.last_name = auth.info.last_name
          user.email = auth.info.email
      
        user.save
      elsif auth.provider == "twitter" 
        
          user.provider = auth.provider
        user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          
          user.oauth_user_name = auth.extra.raw_info.name
           
       elsif auth.provider == "github"         
          
        user.provider = auth["provider"]
        user.uid = auth["uid"]
        
        #user.oauth_user_name = auth ["username"]            
        user.email = auth["info"]["email"]
        user.save
      elsif auth.provider == "google_oauth2"
             
             user.provider = auth.provider
        user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.email = auth.info.email
          # Google's token doesn't last forever
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.save
           end
    end    
  end
  return user
  end
  # For Twitter (save the session eventhough we redirect user to registration page first)
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end  
  end  
  # For Twitter (disable password validation)
  def password_required?
    super && provider.blank?
  end        
end
  # validates :username,
  #   presence: true,
  #   uniqueness: {
  #     case_sensitive: false
  #   }

  # validate :validate_username

  # def validate_username
  #   if User.where(email: username).exists?
  #     errors.add(:username, :invalid)
  #   end
  # end
  #======================================= 
  #        linkedin
  #======================================= 
  # TEMP_EMAIL_PREFIX = 'change@me'
  # TEMP_EMAIL_REGEX = /\Achange@me/

  # validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  # def self.find_for_oauth(auth, signed_in_resource = nil)

  #   # Get the identity and user if they exist
  #   identity = Identity.find_for_oauth(auth)

  #   # If a signed_in_resource is provided it always overrides the existing user
  #   # to prevent the identity being locked with accidentally created accounts.
  #   # Note that this may leave zombie accounts (with no associated identity) which
  #   # can be cleaned up at a later date.
  #   user = signed_in_resource ? signed_in_resource : identity.user

  #   # Create the user if needed
  #   if user.nil?

  #     # Get the existing user by email if the provider gives us a verified email.
  #     # If no verified email was provided we assign a temporary email and ask the
  #     # user to verify it on the next step via UsersController.finish_signup
  #     email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
  #     email = auth.info.email if email_is_verified
  #     user = User.where(:email => email).first if email

  #     # Create the user if it's a new registration
  #     if user.nil?
  #       user = User.new(
  #         name: auth.extra.raw_info.name,
  #         username: auth.info.nickname || auth.uid,
  #         email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
  #         password: Devise.friendly_token[0,20]
  #       )
  #       user.skip_confirmation!
  #       user.save!
  #     end
  #   end

  #   # Associate the identity with the user if needed
  #   if identity.user != user
  #     identity.user = user
  #     identity.save!
  #   end
  #   user
  # end

  # def email_verified?
  #   self.email && self.email !~ TEMP_EMAIL_REGEX
  # end
  #======================================= 
  #        google
  #======================================= 
	# def self.from_omniauth(access_token)
 #    data = access_token.info
 #    user = User.where(email: data['email']).first

 #    # Uncomment the section below if you want users to be created if they don't exist
 #    unless user
 #        user = User.create(email: data['email'],
 #           password: Devise.friendly_token[0,20]
 #        )
 #    end
 #    p user
	# end
   # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.save!
  #   end
  # end

  #======================================= 
  #        twitter
  #======================================= 
  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.update(
  #       email: auth.info.email,
  #       password: Devise.friendly_token[0,20],
  #       username: auth.info.nickname,
  #       remote_avatar_url: auth.info.image,
  #       token: auth.credentials.token,
  #       secret: auth.credentials.secret
  #     )
  #   end
  # end

  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if data = session["devise.twitter_data"]
  #       # user.attributes = params
  #       user.update(
  #         email: params[:email],
  #         password: Devise.friendly_token[0,20],
  #         username: data["info"]["nickname"],
  #         remote_avatar_url: data["info"]["image"],
  #         token: data["credentials"]["token"],
  #         secret: data["credentials"]["secret"]
  #       )
  #     end
  #   end
  # end