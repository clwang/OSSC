class LeaderboardController < ApplicationController

  def index
    @users = Users.all
  end
end
