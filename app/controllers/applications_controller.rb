class ApplicationsController < ApplicationController
  def create
    application = Application.create!(name: params[:name])
    render json: { success: true, token: application.token }
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def index
    applications = Application.all
    render json: applications
  end

  def show
    application = Application.find_by!(token: params[:token])
    render json: application
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end

  def update
    Application.transaction do
      application = Application.lock.find_by!(token: params[:token])
      application.update!(name: params[:name])
    end
    render json: { success: true, message: "successfully updated" }
  rescue StandardError => e
    render json: { success: false, message: e }, status: :bad_request
  end
end
