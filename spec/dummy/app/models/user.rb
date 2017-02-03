class User < ActiveRecord::Base
 	def is_authorised?
	  true
	end

	def is_authorized?(name)
	  true
	end
end