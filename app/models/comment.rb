class Comment < ActiveRecord::Base
  attr_accessible :message

  has_many :votes, :dependent=>:destroy
  belongs_to :user
  belongs_to :post

  validates :message, :presence => true
end
