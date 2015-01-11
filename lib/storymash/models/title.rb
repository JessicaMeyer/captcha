class Title < ActiveRecord::Base
  belongs_to :user
  validates :title, :length => 2..50
end