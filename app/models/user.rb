class User < ActiveRecord::Base
  attr_accessible :email, :isadmin, :password, :username

  has_many :posts, :dependent=>:destroy
  has_many :votes, :dependent=>:destroy
  has_many :comments, :dependent=>:destroy

  validates :username, :presence => true
  validates :password, :presence => true
  validates :email, :presence => true
end
