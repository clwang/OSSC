class RegistrationsController < Devise::RegistrationsController
  
  def create  
    super  
    session[:omniauth] = nil unless @user.new_record?   
  end

  private
  def build_resource(*args)
    super
    if session["devise.github_data"]
      @user.apply_omniauth(session["devise.github_data"])
      data = session["devise.github_data"]
      @user.nickname = data["user_info"]["nickname"]
      @user.valid?
    end
  end
end
