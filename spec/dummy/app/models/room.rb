class Room < ActiveRecord::Base
  include Exporter::EntityExporter
  set_export_validator(:can_export_rooms) {|user| 
    raise RuntimeError, 'Unauthorised' unless user.is_authorised?
  }
end