require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  # Associations
  it { is_expected.to have_many(:bookings).dependent(:destroy) }

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe "#initials" do
    it "returns initials from a full name" do
      user.name = "Іван Петренко"
      expect(user.initials).to eq("ІП")
    end

    it "returns one initial for single-word name" do
      user.name = "Іван"
      expect(user.initials).to eq("І")
    end

    it "returns max two initials even for long names" do
      user.name = "Іван Сергій Петренко"
      expect(user.initials).to eq("ІС")
    end
  end

  describe "Devise" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is invalid without password" do
      user.password = nil
      expect(user).not_to be_valid
    end

    it "is invalid with short password" do
      user.password = "abc"
      expect(user).not_to be_valid
    end
  end
end
