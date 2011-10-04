class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def after_sign_in_path_for(resource)
      stored_location_for(resource) || '/dashboard'
  end
end
