require "rails_helper"
require 'csv'

RSpec.describe Exporter::ExportController, :type => :controller  do
	  routes { Exporter::Engine.routes }

	  before(:all) do
	  	class Exporter::ExportController

	  		protected

	  		def initialize_response_hash
	  			{}
	  		end

	  		def current_user
					nil
	  		end

	  		def current_location
					nil
	  		end
	  	end
	  	@user = FactoryGirl.create(:user)
	  end

	describe "GET /generate" do
	 	it "validates response headers" do
	 		@room = FactoryGirl.create(:room)
	 		allow(Room).to receive(:sentry_approved?).and_return(true)
	 		allow(Room).to receive(:exportable_entities).and_return([@room])
	 		allow(controller).to receive(:current_user).and_return(@user)
	 		get :generate, {entity: :room, format: :csv}
	 		expect(response.status).to eq(200)
	 		expect(response.headers['Content-Type']).to include('text/csv')
	 		expect(response.headers['Content-Disposition']).to include("attachment; filename=room.csv")
	 	end
	 	it "validates response" do
	 		@rooms = []
	 		csv_string = ''
	 		10.times { @rooms << FactoryGirl.create(:room) }
	 		csv_string = CSV.generate do |csv|
			  csv <<  I18n.t("exportables.Room.header_mappings").values
			  @rooms.each do |room|
			  	csv << [room.name, room.number, room.capacity]
			  end
			end
	 		allow(Room).to receive(:sentry_approved?).and_return(true)
	 		allow(Room).to receive(:exportable_entities).and_return(@rooms)
	 		allow(controller).to receive(:current_user).and_return(@user)
	 		get :generate, {entity: :room, format: :csv}
	 		expect(response.body).to eq(csv_string)
	 	end
	end
end