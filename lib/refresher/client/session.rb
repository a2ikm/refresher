require_relative "./api_client"

class Refresher::Client::Session
  def initialize(access_token)
    @access_token = access_token
    @api_client = Refresher::Client::ApiClient.new
  end

  def show_me
    post("/me", {})
  end

  private def get(path)
    @api_client.request(build_headers, :get, path, nil)
  end

  private def post(path, data)
    @api_client.request(build_headers, :post, path, data)
  end

  private def put(path, data)
    @api_client.request(build_headers, :put, path, data)
  end

  private def delete(path, data)
    @api_client.request(build_headers, :delete, path, data)
  end

  private def build_headers
    { "content-type": "application/json", "authorization": "Bearer #{@access_token}" }
  end
end
