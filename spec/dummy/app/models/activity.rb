class Activity < ActiveRecord::Base
  has_many :activity_settings
  has_many :custom_forms
  has_many :meeting_requests

  def self.get_activities_by_users(user, options={})

  end
end
