class Rank < ActiveRecord::Base
  belongs_to :user
  before_save :apply_ranking

  private

  def apply_ranking
    if self.user_points < 50
      self.ranking = "trainee"
    elsif self.user_points < 100
      self.ranking = "apprentice"
    elsif self.user_points < 500
      self.ranking = "master"
    else
      self.ranking = "grand master"
    end
  end
end
