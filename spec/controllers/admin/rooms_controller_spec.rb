require "rails_helper"

shared_examples "a not found Room" do
  it "redirects to the index page" do
    expect(response).to redirect_to admin_rooms_path
  end

  it "sets a warning flash message" do
    expect(flash[:warning]).to eq I18n.t("record_not_found")
  end
end

RSpec.describe Admin::RoomsController, type: :controller do
  let!(:room_type1) { create(:room_type, price_weekday: 50, price_weekend: 60) }
  let!(:room) { create(:room, room_type: room_type1, room_number: 101) }
  let!(:rooms) { create_list(:room, 3, room_type: room_type1) }
  let(:user) { create(:user) }
  let(:mock_pagy) { instance_double("Pagy") }
  let(:valid_attributes) { attributes_for(:room).merge(room_type_id: room_type1.id) }
  let(:invalid_attributes) { { room_number: nil, status: nil } }

  before do
    sign_in user
  end

  describe "GET #index" do
    before do
      allow(controller).to receive(:pagy).and_return([mock_pagy, rooms])
      allow(Room).to receive(:ordered_by_room_number).and_return(Room.all)
      get :index
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end

    it "assigns @room as a new Room" do
      expect(assigns(:room)).to be_a_new(Room)
    end

    it "assigns @rooms to the list of rooms" do
      expect(assigns(:rooms)).to eq(rooms)
    end

    it "assigns @pagy" do
      expect(assigns(:pagy)).to eq(mock_pagy)
    end
  end

  describe "GET #show" do
    context "when the room exists" do
      before { get :show, params: { id: room.id } }

      it "assigns the requested room to @room" do
        expect(assigns(:room)).to eq(room)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "when the room does not exist" do
      before { get :show, params: { id: 999 } }

      it_behaves_like "a not found Room"
    end
  end

  describe "POST #create" do
    context "when the room is successfully created" do
      before { post :create, params: { room: valid_attributes } }

      it "creates a new room" do
        expect(Room.count).to eq(5)
      end

      it "sets a flash success message" do
        expect(flash[:success]).to eq(I18n.t("created"))
      end

      it "redirects to the admin rooms path" do
        expect(response).to redirect_to(admin_rooms_path)
      end
    end

    context "when the room creation fails" do
      before { post :create, params: { room: invalid_attributes } }

      it "does not create a new room" do
        expect(Room.count).to eq(4)
      end

      it "sets a flash danger message" do
        expect(flash[:danger]).to eq(I18n.t("failed"))
      end

      it "redirects to the admin rooms path" do
        expect(response).to redirect_to(admin_rooms_path)
      end
    end
  end

  describe "PUT #update" do
    context "when Room does not exist" do
      before { patch :update, params: { id: -1, room: valid_attributes } }
      it_behaves_like "a not found Room"
    end

    context "when the room is successfully updated" do
      let(:new_attributes) { { room_number: 202, status: "active" } }

      before { put :update, params: { id: room.id, room: new_attributes } }

      it "updates the requested room" do
        room.reload
        expect(room.room_number).to eq(202)
        expect(room.status).to eq("active")
      end

      it "sets a flash success message" do
        expect(flash[:success]).to eq(I18n.t("updated"))
      end

      it "redirects to the admin room path" do
        expect(response).to redirect_to(admin_room_path(room))
      end
    end

    context "when the room update fails" do
      before { put :update, params: { id: room.id, room: invalid_attributes } }

      it "does not update the room" do
        room.reload
        expect(room.room_number).not_to be_nil
      end

      it "sets a flash danger message" do
        expect(flash[:danger]).to eq(I18n.t("failed"))
      end

      it "redirects to the admin room path" do
        expect(response).to redirect_to(admin_room_path(room))
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the room exists" do
      context "and the room is deleted successfully" do
        before { delete :destroy, params: { id: room.id } }

        it "deletes the room" do
          expect(Room.count).to eq(3)
        end

        it "sets a flash success message" do
          expect(flash[:success]).to eq(I18n.t("deleted"))
        end

        it "redirects to the admin rooms path" do
          expect(response).to redirect_to(admin_rooms_path)
        end
      end

      context "and the room cannot be deleted" do
        before do
          allow_any_instance_of(Room).to receive(:destroy).and_return(false)
          delete :destroy, params: { id: room.id }
        end
    
        it "does not delete the room" do
          expect(Room.count).to eq(4)
        end
    
        it "sets a flash danger message" do
          expect(flash[:danger]).to eq(I18n.t("failed"))
        end
    
        it "redirects to the admin rooms path" do
          expect(response).to redirect_to(admin_rooms_path)
        end
      end
    end

    context "when the room does not exist" do
      before { delete :destroy, params: { id: 999 } }

      it_behaves_like "a not found Room"

      it "does not delete any room" do
        expect(Room.count).to eq(4)
      end
    end
  end
end
