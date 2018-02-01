class API::DevicesController < API::ApplicationController
  def create
    @device = Device.create(params.require(:device).permit(:serial_number, :firmware_version))

    render json: @device
  end

  def show
    @device = Device.find(params.require(:id))

    render json: @device
  end
end
