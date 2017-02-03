class User < ActiveRecord::Base
 	def is_authorised?
	  true
	end
end