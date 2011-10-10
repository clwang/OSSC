class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :uid, :nickname 
  has_many :projects
  has_many :user_oauth_tokens, :class_name => "UserOauthToken"
  
  def self.new_with_session(params, session)
    # this method is called before building a resource. We use this to copy any information from the auth hash
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["user_hash"]
        # this actually adds the data to the record that will be in the session
        #user.email = data["email"]
      end
    end
  end

  def apply_omniauth(omniauth)  
    user_oauth_tokens.build(
      :provider => omniauth['provider'], 
      :uid => omniauth['uid'], 
      :access_token => omniauth["credentials"]["token"]
    )  
  end
  
  def password_required?  
    (user_oauth_tokens.empty? || !password.blank?) && super  
  end 
end
