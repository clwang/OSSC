class HomeController < ApplicationController
  require 'oauth2'
  def index
    client = OAuth2::Client.new('303f86ccb8899b1a87c2', '2e8ca901f843cd0bdc230318f884003bea17fbdb', { :site => 'https://github.com', :authorize_url => '/login/oauth/authorize'})
    logger.info { "CLIENT DATA" }
    Rails.logger.info client.inspect
    Rails.logger.info client.methods
        Rails.logger.info client.auth_code.inspect
    auth_code = client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/projects/')
    Rails.logger.info auth_code.inspect
  end

end
