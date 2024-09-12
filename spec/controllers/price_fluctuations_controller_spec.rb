require "rails_helper"

shared_examples "a not found PriceFluctuation" do
  it "redirects to the index page" do
    expect(response).to redirect_to admin_price_fluctuations_path
  end

  it "sets a warning flash message" do
    expect(flash[:warning]).to eq I18n.t("record_not_found")
  end
end

RSpec.describe Admin::PriceFluctuationsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let!(:price_fluctuation) { create(:price_fluctuation) }
  let(:user) { create(:user) }

  let(:valid_attributes) do
    {
      name: "Price Increase",
      start_date: Date.today,
      end_date: Date.today + 1.month,
      rate: 5.0
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      start_date: nil,
      end_date: nil,
      rate: nil
    }
  end
  
  before {sign_in user}

  describe "GET #index" do
    before {allow(PriceFluctuation).to receive(:search_by_name).and_return(PriceFluctuation.all)}
    context "when search params is present" do
      let(:search_params) { { search: { name: "test" } } }

      it "assigns a new PriceFluctuation to @fluctuation" do
        get :index, params: search_params
        expect(assigns(:fluctuation)).to be_a_new(PriceFluctuation)
      end

      it "paginates the search result" do
        paginated_fluctuations = PriceFluctuation.search_by_name("test").limit(Settings.pagy.items).offset(0)
        get :index, params: search_params
        expect(assigns(:fluctuations)).to match_array(paginated_fluctuations)
      end

      it "calculates the correct @start_index" do
        get :index, params: search_params
        expected_start_index = (assigns(:pagy).page - 1) * Settings.pagy.items
        expect(assigns(:start_index)).to eq(expected_start_index)
      end
    end

    context "when search params is not present" do
      it "assigns a new PriceFluctuation to @fluctuation" do
        get :index
        expect(assigns(:fluctuation)).to be_a_new(PriceFluctuation)
      end

      it "paginates all price fluctuations" do
        paginated_fluctuations = PriceFluctuation.limit(Settings.pagy.items).offset(0)
        get :index
        expect(assigns(:fluctuations)).to match_array(paginated_fluctuations)
      end

      it "calculates the correct @start_index" do
        get :index
        expected_start_index = (assigns(:pagy).page - 1) * Settings.pagy.items
        expect(assigns(:start_index)).to eq(expected_start_index)
      end
    end
  end

  describe "GET /show" do
    context "when price fluctuation id valid" do
      it "render show when params id valid" do
        get :show, params: {id: price_fluctuation.id}
        expect(response).to render_template(:show)
      end
    end

    context "when price fluctuation not found" do
      before {get :show, params: {id: -1}}

      it_behaves_like "a not found PriceFluctuation"
    end
  end

  describe "POST /create" do
    context "with valid attributes" do
      it "creates a new PriceFluctuation" do
        expect {
          post :create, params: {price_fluctuation: valid_attributes}
        }.to change(PriceFluctuation, :count).by(1)
      end

      it "redirects to the index page" do
        post :create, params: {price_fluctuation: valid_attributes}
        expect(response).to redirect_to admin_price_fluctuations_path
      end

      it "sets a success flash message" do
        post :create, params: {price_fluctuation: valid_attributes}
        expect(flash[:success]).to eq I18n.t("created")
      end
    end

    context "with invalid attributes" do
      it "does not create a new PriceFluctuation" do
        expect {
          post :create, params: {price_fluctuation: invalid_attributes}
        }.not_to change(PriceFluctuation, :count)
      end

      it "redirects to the index page" do
        post :create, params: {price_fluctuation: invalid_attributes}
        expect(response).to redirect_to admin_price_fluctuations_path
      end

      it "sets a danger flash message" do
        post :create, params: {price_fluctuation: invalid_attributes}
        expect(flash[:danger]).to eq I18n.t("failed")
      end
    end
  end

  describe "PATCH /update" do
    context "when PriceFluctuation does not exist" do
      before {patch :update, params: {id: -1, price_fluctuation: valid_attributes}}
      it_behaves_like "a not found PriceFluctuation"
    end
    
    context "with valid attributes" do
      before {patch :update, params: { id: price_fluctuation.id, price_fluctuation: valid_attributes }}
      it "updates the PriceFluctuation" do
        price_fluctuation.reload
        expect(price_fluctuation.name).to eq "Price Increase"
      end

      it "updates the rate" do
        price_fluctuation.reload
        expect(price_fluctuation.rate).to eq 5.0
      end

      it "updates the start date" do
        price_fluctuation.reload
        expect(price_fluctuation.start_date).to eq Date.today
      end

      it "updates the end date" do
        price_fluctuation.reload
        expect(price_fluctuation.end_date).to eq (Date.today + 1.month)
      end

      it "redirects to the index page" do
        expect(response).to redirect_to admin_price_fluctuations_path
      end

      it "sets a success flash message" do
        expect(flash[:success]).to eq I18n.t("updated")
      end
    end

    context "with invalid attributes" do
      before {patch :update, params: { id: price_fluctuation.id, price_fluctuation: invalid_attributes }}
      it "does not update the name" do
        price_fluctuation.reload
        expect(price_fluctuation.name).not_to eq ""
      end

      it "does not update the start_date" do
        price_fluctuation.reload
        expect(price_fluctuation.start_date).not_to be_nil
      end

      it "does not update the end_date" do
        price_fluctuation.reload
        expect(price_fluctuation.end_date).not_to be_nil
      end

      it "does not update the rate" do
        price_fluctuation.reload
        expect(price_fluctuation.rate).not_to be_nil
      end

      it "redirects to the index page" do
        expect(response).to redirect_to admin_price_fluctuations_path
      end

      it "sets a danger flash message" do
        expect(flash[:danger]).to eq I18n.t("failed")
      end
    end
  end

  describe "DELETE /destroy" do
    context "when PriceFluctuation does not exist" do
      before {delete :destroy, params: {id: -1}}
      it "does not change the number of PriceFluctuation" do
        expect {
          delete :destroy, params: { id: -1 }
        }.not_to change(PriceFluctuation, :count)
      end

      it_behaves_like "a not found PriceFluctuation"
    end

    context "with valid attributes" do
      it "deletes the PriceFluctuation" do
        delete :destroy, params: { id: price_fluctuation.id }
        expect(PriceFluctuation.exists?(price_fluctuation.id)).to be_falsey
      end

      it "when PriceFluctuation exist" do
        delete :destroy, params: { id: price_fluctuation.id }
        expect(flash[:success]).to eq I18n.t("deleted")
      end

      it "sets a danger flash message when deletion fails" do
        allow_any_instance_of(PriceFluctuation).to receive(:destroy).and_return(false)   
        delete :destroy, params: { id: price_fluctuation.id }
        expect(flash[:danger]).to eq I18n.t("failed")
      end

      it "redirects to the index page" do
        delete :destroy, params: { id: price_fluctuation.id }
        expect(response).to redirect_to admin_price_fluctuations_path
      end 
    end
  end
end
