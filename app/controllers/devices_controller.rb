class DevicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @devices = Device.all
  end

  def show
    @device = Device.find(params.require(:id))
    @recent_sensors = @device.sensor_readings.graphable.limit(params[:sensor_reading_limit] || 30).order(:created_at)
  end
end
