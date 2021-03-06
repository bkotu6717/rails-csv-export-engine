require 'csv'
module Exporter
  class ExportController < ApplicationController
    before_filter :authorize_current_user
  	def generate
  	  params.merge!(current_user: current_user, current_location: current_location)
      params[:per_page] = 10000000 if params[:per_page].blank?
  	  headers_and_mappings = @klass.column_headers_and_mappings
  	  objects = @klass.exportable_entities(params)
  	  @export_data = generate_csv(headers_and_mappings, objects)
  	  file_name = "#{params[:entity]}_#{Time.now.strftime("%m/%d/%y_%H:%M_%z")}.csv"
      send_data @export_data, type: 'text/csv; charset=iso-8859-1; header=present', disposition: "attachment; filename=#{file_name}"
  	end

    private

    def authorize_current_user
      @return_data = initialize_response_hash
      @klass = params[:entity].titleize.constantize
      begin
        @klass.sentry_approved?(current_user)
      rescue RuntimeError => e
        @return_data[:status] = 403
        @return_data[:message] = "Unauthorised"
        render json: @return_data and return
      end
    end

    def generate_csv(headers_and_mappings, objects)
      export_data = [headers_and_mappings.values]
      export_data = CSV.generate do |csv|
        csv << headers_and_mappings.values
        objects.collect do |object|
          csv << object.exportable_attributes(headers_and_mappings.keys)
        end
      end
      export_data
    end
  end
end