# app/controllers/api/v1/invitations_controller.rb
class Api::V1::InvitationsController < ApplicationController
  def create
    file = params[:customers_file]
    return render_error('File not provided.', :bad_request) unless file

    invitees = CustomerInvitationService.new(file).call
    render json: invitees, status: :ok
  
  rescue => e
    Rails.logger.error "Invitation processing failed: #{e.message}"
    render_error('Failed to process file.', :internal_server_error)
  end

  private

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
