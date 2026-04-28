class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @week_offset    = params[:week_offset].to_i.clamp(-52, 52)
    @start_of_week  = Date.current.beginning_of_week(:monday) + @week_offset.weeks
    @end_of_week    = @start_of_week + 6.days
    @week_days      = (@start_of_week..@end_of_week).to_a

    @bookings = Booking.active
      .for_week(@start_of_week)
      .includes(:user)
      .order(:date, :start_time)

    @bookings_by_day = @bookings.group_by(&:date)
  end
end
