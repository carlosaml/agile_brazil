# encoding: UTF-8
class Conference < ActiveRecord::Base
  def self.current
    @current_conference ||= Conference.order('year desc').first
  end
end
