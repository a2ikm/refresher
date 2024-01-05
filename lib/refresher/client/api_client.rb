require "json"
require "net/http"
require "uri"

class Refresher::Client::ApiClient
  SuccessResponse = Data.define(:data)
  ErrorResponse = Data.define(:error)
  UnauthorizedResponse = Class.new(ErrorResponse)

  def request(headers, method, path, data)
    uri = URI("http://localhost:3000#{path}")

    res = case method
    when :get
      Net::HTTP.get(uri, headers)
    when :post
      Net::HTTP.post(uri, data.to_json, headers)
    when :put
      Net::HTTP.put(uri, data.to_json, headers)
    when :delete
      Net::HTTP.delete(uri, data.to_json, headers)
    else
      raise ArgumentError, "unsupported method: #{method}"
    end

    case res
    when Net::HTTPSuccess
      SuccessResponse.new(JSON.parse(res.body))
    when Net::HTTPUnauthorized
      UnauthorizedResponse.new(JSON.parse(res.body)["error"])
    when Net::HTTPClientError, Net::HTTPServerError
      ErrorResponse.new(JSON.parse(res.body)["error"])
    else
      ErrorResponse.new("Unknown error: #{res.inspect}")
    end
  end
end
