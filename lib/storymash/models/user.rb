class User < ActiveRecord::Base
  validates :username, :presence => {:message => "Username can't be blank."}
  validates :username, :uniqueness => {:message => "Username already exists."}
  validates :username, :length => 4..12
  validates :password, :presence => {:message => "Password can't be blank."}
  validates :password, :length => { :minimum => 6, :message => "Must be at least 6 characters."}
  validates :password, :format => { with: /\d+[a-zA-Z]+|[a-zA-Z]+\d+/ }
end