module ApiHelpers
  def auth_headers
    { "Authorization" => "Token #{Rails.application.credentials.api_token}" }
  end
end
