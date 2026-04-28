require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  let(:user)  { create(:user) }
  let(:other) { create(:user) }

  before { sign_in user }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "pre-fills date from params" do
      get :new, params: { date: "2025-06-15" }
      expect(assigns(:booking).date).to eq(Date.parse("2025-06-15"))
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      { booking: { date: Date.current + 1.day, start_time: "12:00", end_time: "15:00", notes: "Test" } }
    end

    context "with valid params" do
      it "creates a new booking" do
        expect { post :create, params: valid_params }.to change(Booking, :count).by(1)
      end

      it "redirects to root" do
        post :create, params: valid_params
        expect(response).to redirect_to(root_path)
      end

      it "sets a success flash notice" do
        post :create, params: valid_params
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid params" do
      it "does not create a booking when end_time <= start_time" do
        params = { booking: { date: Date.current + 1.day, start_time: "15:00", end_time: "12:00" } }
        expect { post :create, params: params }.not_to change(Booking, :count)
      end

      it "renders new with unprocessable_entity status" do
        params = { booking: { date: Date.current - 1.day, start_time: "12:00", end_time: "15:00" } }
        post :create, params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    let(:booking) { create(:booking, user: user) }

    context "as owner" do
      it "updates the booking" do
        patch :update, params: { id: booking.id, booking: { notes: "Updated" } }
        expect(booking.reload.notes).to eq("Updated")
      end

      it "redirects to root on success" do
        patch :update, params: { id: booking.id, booking: { notes: "Updated" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "as non-owner" do
      before { sign_in other }

      it "redirects to root with alert" do
        patch :update, params: { id: booking.id, booking: { notes: "Hacked" } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end

      it "does not update the booking" do
        original_notes = booking.notes
        patch :update, params: { id: booking.id, booking: { notes: "Hacked" } }
        expect(booking.reload.notes).to eq(original_notes)
      end
    end
  end

  describe "PATCH #cancel" do
    let(:booking) { create(:booking, user: user) }

    context "as owner" do
      it "cancels a confirmed booking" do
        patch :cancel, params: { id: booking.id }
        expect(booking.reload).to be_cancelled
      end

      it "redirects with notice" do
        patch :cancel, params: { id: booking.id }
        expect(flash[:notice]).to be_present
      end
    end

    context "when already cancelled" do
      let(:booking) { create(:booking, :cancelled, user: user) }

      it "redirects with alert" do
        patch :cancel, params: { id: booking.id }
        expect(flash[:alert]).to be_present
      end
    end

    context "as non-owner" do
      before { sign_in other }

      it "does not cancel the booking" do
        patch :cancel, params: { id: booking.id }
        expect(booking.reload).to be_confirmed
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:booking) { create(:booking, user: user) }

    context "as owner" do
      it "destroys the booking" do
        expect { delete :destroy, params: { id: booking.id } }.to change(Booking, :count).by(-1)
      end
    end

    context "as non-owner" do
      before { sign_in other }

      it "does not destroy the booking" do
        expect { delete :destroy, params: { id: booking.id } }.not_to change(Booking, :count)
      end
    end
  end

  describe "unauthenticated access" do
    before { sign_out user }

    it "redirects to sign in" do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
