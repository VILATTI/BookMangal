require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "GET #home" do
    let(:monday) { Date.current.beginning_of_week(:monday) }

    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end

    it "assigns the current week by default" do
      get :home
      expect(assigns(:start_of_week)).to eq(monday)
      expect(assigns(:week_days).size).to eq(7)
    end

    it "shifts week by offset" do
      get :home, params: { week_offset: 1 }
      expect(assigns(:start_of_week)).to eq(monday + 1.week)
    end

    it "groups bookings by day" do
      booking = create(:booking, date: monday + 1)
      get :home
      expect(assigns(:bookings_by_day)[monday + 1]).to include(booking)
    end

    it "excludes cancelled bookings" do
      cancelled = create(:booking, :cancelled, date: monday + 1)
      get :home
      all_bookings = assigns(:bookings_by_day).values.flatten
      expect(all_bookings).not_to include(cancelled)
    end

    it "is accessible without authentication" do
      get :home
      expect(response).not_to redirect_to(new_user_session_path)
    end
  end
end
