class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :users, :through => :todo
  validates :title, :presence => true
  validates :description, :presence => true
end
