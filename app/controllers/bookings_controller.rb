class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :cancel]
  before_action :authorize_booking!, only: [:edit, :update, :destroy, :cancel]

  def show; end

  def new
    @booking            = current_user.bookings.build
    @booking.date       = params[:date] ? Date.parse(params[:date]) : Date.current
    @booking.start_time = params[:hour] ? "#{params[:hour]}:00" : "12:00"
    @booking.end_time   = params[:hour] ? "#{params[:hour].to_i + 2}:00" : "14:00"
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    if @booking.save
      redirect_to root_path, notice: "Мангал заброньовано! 🎉 #{@booking.date.strftime('%d.%m')} о #{@booking.time_range}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @booking.update(booking_params)
      redirect_to root_path, notice: "Бронювання оновлено ✅"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to root_path, notice: "Бронювання видалено."
  end

  def cancel
    if @booking.confirmed?
      @booking.update!(status: :cancelled)
      redirect_to root_path, notice: "Бронювання скасовано."
    else
      redirect_to root_path, alert: "Це бронювання вже скасовано."
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:date, :start_time, :end_time, :notes)
  end

  def authorize_booking!
    redirect_to root_path, alert: "Доступ заборонено." unless @booking.user == current_user
  end
end
