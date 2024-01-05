require_relative "./api_client"
require_relative "./session"

class Refresher::Client::Login
  def initialize(name, password)
    @name = name
    @password = password
    @api_client = Refresher::Client::ApiClient.new
  end

  def run
    data = { name: @name, password: @password }
    headers = { "content-type": "application/json" }
    res = @api_client.request(headers, :post, "/sessions", data)

    case res
    when Refresher::Client::ApiClient::SuccessResponse
      Refresher::Client::Session.new(res.data["access_token"], res.data["refresh_token"])
    else
      raise res.error
    end
  end
end
