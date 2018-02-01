class AlertsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_alert, only: [:hide]

  def hide
    @alert.update_attributes!(hidden_at: Time.now)
    flash[:success] = "Alert dismissed"
    redirect_to :root
  end

  protected

  def fetch_alert
    @alert = SensorAlert.find(params.require(:id))
  end
end
