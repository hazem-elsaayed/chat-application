class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  def route_not_found
    render json: {success: false, message: 'request url not found'}, status: :not_found, layout: false
  end    
end
