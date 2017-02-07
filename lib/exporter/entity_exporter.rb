module Exporter
  module EntityExporter
    def self.included(klass)
      klass.extend ClassMethods
      klass.send :include, InstanceMethods
    end

    module ClassMethods
     
      def set_export_validator(privilege = nil, &block)
        @privilege = privilege
        @validate_block = block
      end

      def sentry_approved?(current_user)
        if !@validate_block.blank?
          return @validate_block.call(current_user)
        elsif defined?(@privilege) and !@privilege.blank?
          return validated_privilege?(current_user)
        elsif @validate_block.blank?
          return true
        end
      end

      def validated_privilege?(current_user)
        raise RuntimeError, 'Unauthorised' unless current_user.authorised?(@privilege.to_sym)
        true
      end

      def exportable_entities(options = {})
        []
      end

  	  def column_headers_and_mappings
  	    I18n.t("exportables.#{self.to_s}.header_mappings")
  	  end
    end

    module InstanceMethods
  	  def exportable_attributes(attributes_names = self.class.column_headers_and_mappings.keys)
        csv_row = []
        attributes_names.each{|attr_name| csv_row << self.send(attr_name.to_sym)}
  	    csv_row
  	  end
    end
  end
end