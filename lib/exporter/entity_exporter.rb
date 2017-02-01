module Exporter
  module EntityExporter
    def self.included(klass)
      klass.extend ClassMethods
      klass.send :include, InstanceMethods
    end

    module ClassMethods
      def set_export_validator(&block)
        @validate_block = block
      end

      def sentry_approved?(current_user)
        return true if @validate_block.blank?
        @validate_block.call(current_user)
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