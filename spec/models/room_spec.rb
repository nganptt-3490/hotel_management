require "rails_helper"

RSpec.describe Room, type: :model do
  describe "associations" do
    it { should belong_to(:room_type) }
    it { should have_many(:requests).dependent(:destroy) }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values([:active, :inactive]) }
  end

  describe "validations" do
    it { should validate_presence_of(:room_number) }
    it { should validate_presence_of(:status) }
  end

  describe "scopes" do
    let!(:room_type1) { create(:room_type, price_weekday: 50, price_weekend: 60) }
    let!(:room_type2) { create(:room_type, price_weekday: 100, price_weekend: 120) }
    let!(:room1) { create(:room, room_type: room_type1, room_number: 101) }
    let!(:room2) { create(:room, room_type: room_type2, room_number: 102) }

    describe ".excluding_ids" do
      context "when room ids are excluded" do
        it "does not include the room with the excluded id" do
          expect(Room.excluding_ids([room1.id])).not_to include(room1)
        end

        it "includes the room that is not excluded" do
          expect(Room.excluding_ids([room1.id])).to include(room2)
        end
      end
    end

    describe ".by_ids" do
      context "when matching ids are provided" do
        it "includes the rooms with the given ids" do
          expect(Room.by_ids([room1.id, room2.id])).to include(room1, room2)
        end
      end
    end

    describe ".by_room_type_price_range" do
      context "when price range includes room1" do
        it "includes room1 within the given price range" do
          expect(Room.by_room_type_price_range(40, 60)).to include(room1)
        end
      end

      context "when price range does not include room2" do
        it "does not include room2 within the given price range" do
          expect(Room.by_room_type_price_range(40, 60)).not_to include(room2)
        end
      end
    end

    describe ".ordered_by_room_number" do
      context "when ordered by room number ascending" do
        it "orders rooms by room number in ascending order" do
          expect(Room.ordered_by_room_number).to eq([room1, room2])
        end
      end
    end

    describe ".by_type_and_ids" do
      context "when room_type_id and available_room_ids match room1" do
        it "includes room1 with matching room_type_id and room_id" do
          expect(Room.by_type_and_ids(room_type1.id, [room1.id])).to include(room1)
        end
      end

      context "when room_type_id and available_room_ids do not match room2" do
        it "does not include room2 with different room_type_id" do
          expect(Room.by_type_and_ids(room_type1.id, [room1.id])).not_to include(room2)
        end
      end
    end
  end

  describe ".ransackable_attributes" do
    it "includes 'room_number' as a ransackable attribute" do
      expect(Room.ransackable_attributes).to include("room_number")
    end
  end
end
