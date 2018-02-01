class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @alerts = SensorAlert.where(hidden_at: nil)
  end
end
