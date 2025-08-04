class ApplicationController < ActionController::API
  before_action :authenticate_token!

  private

  def authenticate_token!
    token = request.headers["Authorization"]&.split("Token ")&.last

    unless token && secure_compare(token, expected_token)
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def expected_token
    Rails.application.credentials.api_token
  end

  def secure_compare(a, b)
    ActiveSupport::SecurityUtils.secure_compare(a.to_s, b.to_s)
  end
end
