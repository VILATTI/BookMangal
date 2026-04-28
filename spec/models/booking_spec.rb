require "rails_helper"

RSpec.describe Booking, type: :model do
  subject(:booking) { build(:booking) }

  # Associations
  it { is_expected.to belong_to(:user) }

  # Validations — presence
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }

  # Enum
  it { is_expected.to define_enum_for(:status).with_values(confirmed: 0, cancelled: 1) }

  describe "scopes" do
    let!(:confirmed_booking)  { create(:booking) }
    let!(:cancelled_booking)  { create(:booking, :cancelled) }

    describe ".active" do
      it "returns only confirmed bookings" do
        expect(Booking.active).to include(confirmed_booking)
        expect(Booking.active).not_to include(cancelled_booking)
      end
    end

    describe ".for_week" do
      let(:start_date) { Date.current.beginning_of_week(:monday) }

      it "returns bookings within the given week" do
        booking_this_week  = create(:booking, date: start_date + 2)
        booking_next_week  = create(:booking, date: start_date + 8)

        results = Booking.for_week(start_date)
        expect(results).to include(booking_this_week)
        expect(results).not_to include(booking_next_week)
      end
    end
  end

  describe "validations" do
    describe "end_time_after_start_time" do
      it "is invalid when end_time is before start_time" do
        booking.start_time = "15:00"
        booking.end_time   = "12:00"
        expect(booking).not_to be_valid
        expect(booking.errors[:end_time]).to be_present
      end

      it "is invalid when end_time equals start_time" do
        booking.start_time = "12:00"
        booking.end_time   = "12:00"
        expect(booking).not_to be_valid
      end

      it "is valid when end_time is after start_time" do
        booking.start_time = "12:00"
        booking.end_time   = "15:00"
        expect(booking).to be_valid
      end
    end

    describe "within_operating_hours" do
      it "is invalid when start_time is before 08:00" do
        booking.start_time = "07:00"
        expect(booking).not_to be_valid
        expect(booking.errors[:start_time]).to be_present
      end

      it "is invalid when end_time is after 22:00" do
        booking.start_time = "20:00"
        booking.end_time   = "23:00"
        expect(booking).not_to be_valid
        expect(booking.errors[:end_time]).to be_present
      end

      it "is valid within operating hours" do
        booking.start_time = "08:00"
        booking.end_time   = "22:00"
        expect(booking).to be_valid
      end
    end

    describe "no_overlap" do
      let!(:existing) do
        create(:booking, date: Date.current + 1.day, start_time: "12:00", end_time: "15:00")
      end

      it "is invalid when times overlap with existing booking" do
        overlapping = build(:booking,
          user:       existing.user,
          date:       existing.date,
          start_time: "13:00",
          end_time:   "16:00")
        expect(overlapping).not_to be_valid
        expect(overlapping.errors[:base]).to be_present
      end

      it "is valid when times are adjacent (no overlap)" do
        adjacent = build(:booking,
          date:       existing.date,
          start_time: "15:00",
          end_time:   "18:00")
        expect(adjacent).to be_valid
      end

      it "is valid on a different date" do
        different_day = build(:booking,
          date:       existing.date + 1,
          start_time: "12:00",
          end_time:   "15:00")
        expect(different_day).to be_valid
      end
    end

    describe "date validation on create" do
      it "is invalid with a past date on create" do
        booking.date = Date.current - 1.day
        expect(booking).not_to be_valid
      end

      it "is valid with today's date on create" do
        booking.date = Date.current
        expect(booking).to be_valid
      end
    end
  end

  describe "#time_range" do
    it "returns formatted time range string" do
      booking.start_time = Time.parse("12:00")
      booking.end_time   = Time.parse("15:30")
      expect(booking.time_range).to eq("12:00 – 15:30")
    end
  end

  describe "#duration_hours" do
    it "calculates the duration correctly" do
      booking.start_time = Time.parse("10:00")
      booking.end_time   = Time.parse("13:00")
      expect(booking.duration_hours).to eq(3.0)
    end
  end
end
