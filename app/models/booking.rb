class Booking < ApplicationRecord
  belongs_to :user

  enum :status, { confirmed: 0, cancelled: 1 }

  OPERATING_START = 8   # 08:00
  OPERATING_END   = 22  # 22:00

  HOURS = (OPERATING_START...OPERATING_END).map { |h| "#{format('%02d', h)}:00" }

  validates :date,       presence: true
  validates :start_time, presence: true
  validates :end_time,   presence: true
  validates :date,
    comparison: { greater_than_or_equal_to: -> { Date.current } },
    on: :create

  validate :end_time_after_start_time
  validate :within_operating_hours
  validate :no_overlap, on: [:create, :update]

  scope :active,    -> { where(status: :confirmed) }
  scope :for_week,  ->(start_date) { where(date: start_date..start_date + 6.days) }

  def time_range
    "#{start_time.strftime('%H:%M')} – #{end_time.strftime('%H:%M')}"
  end

  def duration_hours
    ((end_time - start_time) / 3600).round(1)
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time
    errors.add(:end_time, "має бути пізніше часу початку") if end_time <= start_time
  end

  def within_operating_hours
    return unless start_time && end_time
    errors.add(:start_time, "має бути не раніше 08:00") if start_time.hour < OPERATING_START
    errors.add(:end_time,   "має бути не пізніше 22:00") if end_time.hour > OPERATING_END || (end_time.hour == OPERATING_END && end_time.min > 0)
  end

  def no_overlap
    return unless date && start_time && end_time
    overlapping = Booking.active
                         .where(date: date)
                         .where.not(id: id)
                         .where("start_time < ? AND end_time > ?", end_time, start_time)
    errors.add(:base, "Цей час вже зайнятий іншим бронюванням") if overlapping.exists?
  end
end
