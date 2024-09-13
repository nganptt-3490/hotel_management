require "rails_helper"

RSpec.describe PriceFluctuation, type: :model do
  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:start_date)}
    it {should validate_presence_of(:end_date)}
    it {should validate_presence_of(:rate)}
  end

  describe "associations" do
    it {should have_many(:room_costs).dependent(:destroy)}
  end

  describe ".search_by_name" do
    let!(:fluctuation1){create(:price_fluctuation, name: "Summer Promotion")}
    let!(:fluctuation2){create(:price_fluctuation, name: "Winter Discount")}
    let!(:fluctuation3){create(:price_fluctuation, name: "Holiday Sale")}

    context "when name is present" do
      let(:result) { PriceFluctuation.search_by_name("Promotion") }

      it "includes the correct fluctuation" do
        expect(result).to include(fluctuation1)
      end
      
      it "does not include other fluctuations" do
        expect(result).not_to include(fluctuation2, fluctuation3)
      end
    end

    context "when name is not present" do
      it "returns all fluctuations" do
        result = PriceFluctuation.search_by_name(nil)
        expect(result).to include(fluctuation1, fluctuation2, fluctuation3)
      end
    end
  end

  describe "creating a PriceFluctuation" do
    let(:valid_attributes) do
      {name: "Summer Sale", start_date: Date.today, end_date: Date.today + 1.month, rate: 10.0}
    end

    it "is valid with valid attributes" do
      fluctuation = PriceFluctuation.new(valid_attributes)
      expect(fluctuation).to be_valid
    end

    it "is invalid without a name" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:name))
      expect(fluctuation).not_to be_valid
    end
    
    it "returns error message for missing name" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:name))
      fluctuation.valid?
      expect(fluctuation.errors[:name]).to include("can't be blank")
    end
    
    it "is invalid without a start date" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:start_date))
      expect(fluctuation).not_to be_valid
    end
    
    it "returns error message for missing start date" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:start_date))
      fluctuation.valid?
      expect(fluctuation.errors[:start_date]).to include("can't be blank")
    end
    
    it "is invalid without an end date" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:end_date))
      expect(fluctuation).not_to be_valid
    end
    
    it "returns error message for missing end date" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:end_date))
      fluctuation.valid?
      expect(fluctuation.errors[:end_date]).to include("can't be blank")
    end
    
    it "is invalid without a rate" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:rate))
      expect(fluctuation).not_to be_valid
    end
    
    it "returns error message for missing rate" do
      fluctuation = PriceFluctuation.new(valid_attributes.except(:rate))
      fluctuation.valid?
      expect(fluctuation.errors[:rate]).to include("can't be blank")
    end    
  end
end
