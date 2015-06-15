class Post < ActiveRecord::Base
  attr_accessible :message, :title,:category_id

  has_many :comments, :dependent=>:destroy
  has_many :votes, :dependent=>:destroy
  belongs_to :category
  belongs_to :user

  validates :title, :presence => true
  validates :message, :presence => true
end
