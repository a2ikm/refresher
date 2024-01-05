require_relative "./api_client"

class Refresher::Client::Session
  def initialize(access_token, refresh_token)
    @access_token = access_token
    @refresh_token = refresh_token
    @api_client = Refresher::Client::ApiClient.new
  end

  def show_me
    post("/me", {})
  end

  private def get(path)
    request(:get, path, nil)
  end

  private def post(path, data)
    request(:post, path, data)
  end

  private def put(path, data)
    request(:put, path, data)
  end

  private def delete(path, data)
    request(:delete, path, data)
  end

  private def request(method, path, data)
    begin
      res = @api_client.request(build_headers, method, path, data)

      if res.is_a?(Refresher::Client::ApiClient::UnauthorizedResponse)
        refresh

        # NOTE: raise exception to retry
        raise
      end

      res
    rescue
      retry
    end
  end

  private def build_headers
    { "content-type": "application/json", "authorization": "Bearer #{@access_token}" }
  end

  private def refresh
    # TODO: refresh and update @access_token and @refresh_token
  end
end
