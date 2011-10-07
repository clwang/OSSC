class HomeController < ApplicationController
  def index
    Rails.logger.info "Current user is :#{current_user.inspect}"
    Rails.logger.info "Current session is :  #{session.inspect}"
  end

end
