class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }

  def initials
    name.split.map(&:first).first(2).join.upcase
  end
end
