# encoding: UTF-8
class SessionType < ActiveRecord::Base

  validates_presence_of :title, :description

  has_many :sessions
  
end
