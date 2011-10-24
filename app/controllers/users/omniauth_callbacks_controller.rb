class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def github
    auth = request.env["omniauth.auth"]
    token = UserOauthToken.find_by_provider_and_uid(auth["provider"], auth["uid"].to_s)
    
    if token
      Rails.logger.info "user has persisted"
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
      sign_in_and_redirect(:user, token.user)
    elsif current_user
      Rails.logger.info "associated the current user and the github account"
      current_user.user_oauth_tokens.create!(:provider => auth["provider"], :uid => auth["uid"].to_s, :access_token => auth["credentials"]["token"] )
      flash[:notice] = "Successfully associated your Github account"
      redirect_to dashboard_path()
    else
      user = User.new
      user.apply_omniauth(auth)
      
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        session["devise.github_data"] = env["omniauth.auth"]
        redirect_to new_user_registration_url  
      end
    end
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end