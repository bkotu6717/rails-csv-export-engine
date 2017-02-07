class User < ActiveRecord::Base
	def authorized?
	  true
	end

	def authorised?(name)
		true
	end
end