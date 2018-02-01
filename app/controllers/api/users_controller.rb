class API::UsersController < API::ApplicationController
  def current
    render json: @consumer
  end
end
