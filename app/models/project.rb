class Project < ActiveRecord::Base
  belongs_to :user
  has_many :tasks
  validates :name, :presence => true
end
