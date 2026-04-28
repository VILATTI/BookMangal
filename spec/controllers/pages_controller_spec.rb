require "rails_helper"

RSpec.describe PagesController do
  render_views

  describe "GET #home" do
    let(:monday) { Date.current.beginning_of_week(:monday) }

    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end

    it "is accessible without authentication" do
      get :home
      expect(response).not_to redirect_to(new_user_session_path)
    end

    it "responds successfully with next week offset" do
      get :home, params: { week_offset: 1 }
      expect(response).to have_http_status(:success)
    end

    it "shows confirmed bookings in response body" do
      user = create(:user)
      _booking = create(:booking, user:, date: monday + 1)
      get :home
      expect(response.body).to include(user.name.split.first)
    end

    it "does not show cancelled bookings" do
      user    = create(:user)
      booking = create(:booking, :cancelled, user:, date: monday + 1)
      get :home
      expect(response.body).not_to include(booking.time_range)
    end
  end
end
