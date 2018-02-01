class API::SensorReadingsController < API::ApplicationController
  skip_before_action :encrypted_api_authentication, only: [:ajax]
  before_action :basic_api_authentication, only: [:ajax]

  def create
    @reading = SensorReading.new(params.require(:sensor_reading).permit(:value, :type, :read_at).merge(device: device))

    if @reading.save
      render json: @reading
    else
      render json: @reading.errors, status: 400
    end
  end

  def bulk_upload
    if params[:sensor_readings].count > 500
      return render json: {"errors" => "bulk sensor upload is limited to 500 items"}, status: 400
    end

    if params[:sensor_readings].any? { |sr| sr[:value].nil? || sr[:type].nil? || sr[:read_at].nil? }
      return render json: {"errors" => "1 or more sensor readings are invalid: cannot process bulk upload. all sensor readings require a value, type, and read_at"}, status: 400
    end

    SensorReading.bulk_insert do |worker|
      params[:sensor_readings].each do |sensor|
        worker.add(sensor.permit(:type, :value, :read_at).to_h.merge(device_id: device.id))
      end
    end

    render json: {"success" => "bulk upload complete"}, status: 201
  end

  def ajax
    options = ""
    order = ""
    sensor, time = params["columns"].values.map { |v| v["search"]["value"] }.reject(&:blank?)

    return render json: [{}], serializer: nil unless sensor && time

    options << "read_at >= '#{time_mapping[time]}'" unless time == 'all'
    options << " and " if !options.blank? && sensor && sensor != 'all'
    options << "type in ('#{sensor}')" unless sensor == 'all'

    if order_params = params["order"] && params["order"]["0"]
      case order_params["column"]
      when "0"
        order = "type "
      when "1"
        if %w(UnitHealth all).include?(sensor)
          order = "value "
        else
          order = "CAST(value as decimal) "
        end
      when "2"
        order = "read_at "
      end

      order << order_params["dir"]
    end

    page = (params[:start].to_i / params[:length].to_i) + 1
    sensor_readings = device.sensor_readings.where(options).order(order)
    filtered_sensor_readings = sensor_readings.page(page).per(params[:length].to_i)

    response_data = {"recordsTotal" => sensor_readings.count, "recordsFiltered" => filtered_sensor_readings.total_count, draw: params[:draw].to_i, data: filtered_sensor_readings.map { |s| [s.type, s.value, s.read_at] }}

    render json: response_data
  end

  protected

  def device
    @_device ||= Device.find(params.require(:device))
  end

  def time_mapping
    # clarify if this is beginning of timeframe, or the last period of time
    {
      "today"      => Time.now.midnight,
      "this_week"  => Time.now.beginning_of_week,
      "this_month" => Time.now.beginning_of_month,
      "this_year"  => Time.now.beginning_of_year,
    }
  end
end
