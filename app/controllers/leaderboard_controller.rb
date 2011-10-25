class LeaderboardController < ApplicationController

  def index
    @rankings = Rank.order("user_points DESC")
  end
end
