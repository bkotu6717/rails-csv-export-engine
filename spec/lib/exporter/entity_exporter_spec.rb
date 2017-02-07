require 'rails_helper'

describe Exporter::EntityExporter do

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

  describe ".sentry_approved?(current_user)" do
    it "should authorize for no privilage and no block provided" do
      user = FactoryGirl.create(:user)
      Room.set_export_validator
      expect(Room.sentry_approved?(user)).to eq(true)
    end
    it "should authorize for given privilage" do
      user = FactoryGirl.create(:user)
      Room.set_export_validator(:can_export_rooms)
      expect(Room.sentry_approved?(user)).to eq(true)
    end
    it "should authorize for given block" do
     user = FactoryGirl.create(:user)
      Room.set_export_validator { |user|
        raise RuntimeError, 'Unauthorised' unless user.authorized?
      }
      expect { Room.sentry_approved?(user) }.not_to raise_error
    end
    it "should unauthorize for a given privilage" do
      user = FactoryGirl.create(:user)
      allow(user).to receive(:authorised?).with(:can_export_rooms).and_return(false)
      Room.set_export_validator(:can_export_rooms)
      expect { Room.sentry_approved?(user) }.to raise_error(RuntimeError)
    end
    it "should unauthorize for a given block" do
      user = FactoryGirl.create(:user)
      allow(user).to receive(:authorized?).and_return(false)
      Room.set_export_validator { |user|
        raise RuntimeError, 'Unauthorised' unless user.authorized?
      }
      expect { Room.sentry_approved?(user) }.to raise_error(RuntimeError)
    end
    it "should authorize for a given block and privilage" do
      user = FactoryGirl.create(:user)
      Room.set_export_validator(:can_export_rooms) { |user|
        raise RuntimeError, 'Unauthorised' unless user.authorized?
      }
      expect { Room.sentry_approved?(user) }.not_to raise_error
    end
    it "should unauthorize for given block and privilage" do
      user = FactoryGirl.create(:user)
      allow(user).to receive(:authorized?).and_return(false)
      Room.set_export_validator(:can_export_rooms) { |user|
        raise RuntimeError, 'Unauthorised' unless user.authorized?
      }
      expect { Room.sentry_approved?(user) }.to raise_error(RuntimeError)
    end
  end
end