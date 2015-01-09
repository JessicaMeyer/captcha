#require 'active_record'

class Session < ActiveRecord::Base
  belongs_to :user
end