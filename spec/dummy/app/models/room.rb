class Room < ActiveRecord::Base
	include Exporter::EntityExporter
  set_export_validator {|user| 
    raise RuntimeError, 'Unauthorised' unless user.is_authorised?
  }
end