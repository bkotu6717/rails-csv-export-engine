require 'rails_helper'

describe Exporter::EntityExporter do

  describe ".sentry_approved?" do
    it "should be sentry approved user" do
      user = FactoryGirl.create(:user)
      expect{ Room.sentry_approved?(user) }.not_to raise_error
    end

    it "it should not be sentry approved user" do
      user = FactoryGirl.create(:user)
      allow(user).to receive(:is_authorized?).and_return(false)
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
      room = FactoryGirl.create(:room, name: 'Amruthesh', number: '45678', capacity: 20)
      expect(room.exportable_attributes([:name, :number, :capacity])).to eq(["Amruthesh", "45678", 20])
    end
  end

  describe ".validated_privilage?(current_user)" do
    it "it should unauthorize for no privilage and no block provided" do
      user = FactoryGirl.create(:user)
      Room.set_export_validator
      expect(Room.sentry_approved?(user)).to eq(false)
    end
    it "it should authorize for given privilage" do
      user = FactoryGirl.create(:user)
      Room.set_export_validator(:can_export_rooms)
      expect(Room.sentry_approved?(user)).to eq(true)
    end
    it "it should unauthorize for a given block" do
      user = FactoryGirl.create(:user)
      allow(user).to receive(:is_authorized?).and_return(false)
      Room.set_export_validator { |user|
        raise RuntimeError, 'Unauthorised' unless user.is_authorized?
      }
      expect { Room.sentry_approved?(user) }.to raise_error(RuntimeError)
    end
    it "it should authorize for a given block" do
      user = FactoryGirl.create(:user)
      Room.set_export_validator { |user|
        raise RuntimeError, 'Unauthorised' unless user.is_authorized?
      }
      expect { Room.sentry_approved?(user) }.not_to raise_error
    end
    it "it should authorize for a given block and privilage" do
      user = FactoryGirl.create(:user)
      Room.set_export_validator(:can_export_rooms) { |user|
        raise RuntimeError, 'Unauthorised' unless user.is_authorized?
      }
      expect { Room.sentry_approved?(user) }.not_to raise_error
    end
    it "it should unauthorize for given block and privilage" do
      user = FactoryGirl.create(:user)
      allow(user).to receive(:is_authorized?).and_return(false)
      Room.set_export_validator(:can_export_rooms) { |user|
        raise RuntimeError, 'Unauthorised' unless user.is_authorized?
      }
      expect { Room.sentry_approved?(user) }.to raise_error(RuntimeError)
    end
  end
end