class User < ActiveRecord::Base
	def is_authorized?(name = nil)
	  true
	end
end