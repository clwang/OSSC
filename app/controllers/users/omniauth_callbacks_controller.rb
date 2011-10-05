class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def github
    # You need to implement the method below in your model
    @user = User.find_for_github_oauth(env["omniauth.auth"], current_user)
    Rails.logger.info @user.inspect
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Github"
      sign_in_and_redirect @user, :event => :authentication
    else
      # stores all the github data in the session hash
      # then redirect to a page to fill in more information, but we should instead save the user in the database
      # we need to figure out what data we want to store in terms of what is currently available to the github api
      # we definitely need to store the user's github api token so we can access their stuff
      session["devise.github_data"] = env["omniauth.auth"]
      # redirect_to new_user_registration_url
      # currently this does not sign you in. So we actually need to get the user into a signed in state
      redirect_to dashboard_path()
    end
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end