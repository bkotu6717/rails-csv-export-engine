require 'rails_helper'

describe Exporter::EntityExporter do

  describe ".sentry_approved?" do
    it "should be sentry approved user" do
      user = FactoryGirl.create(:user)
      expect{ Room.sentry_approved?(user) }.not_to raise_error
    end

    it "it should not be sentry approved user" do
      user = FactoryGirl.create(:user)
      allow(user).to receive(:is_authorised?).and_return(false)
      expect{ Room.sentry_approved?(user) }.to raise_error(RuntimeError)
      expect { raise RuntimeError, 'Unauthorised'}.to raise_error('Unauthorised')
    end
  end

  describe ".exportable_entities" do
    it "should return empty exportable entities" do
      expect(Room.exportable_entities).to eq([])  
    end
  end

  describe ".column_headers_and_mappings" do
    it "should return configured column headers and mappings" do
      configured_mappings = {name: 'Meeting Room', number: "Number", capacity: "Capacity"}
      expect(Room.column_headers_and_mappings.with_indifferent_access).to match(configured_mappings)
    end
  end

  describe ".exportable_attributes" do
    it "should return exportable attributes" do
      room = Room.new(name: 'Amruthesh', number: '45678', capacity: 20)
      expect(room.exportable_attributes([:name, :number, :capacity])).to eq(["Amruthesh", "45678", 20])
    end
  end

  describe ".validated_privilege?(current_user)" do
    it "validates if there is a privilege" do
      user = User.new
      Room.restrict_export_by_privilege(:privilege_name)
      expect{ Room.sentry_approved?(user) }.not_to raise_error
      allow(user).to receive(:is_authorized?).and_return(false)
      expect{ Room.sentry_approved?(user) }.to raise_error
      Room.restrict_export_by_privilege(nil)
    end
  end
end