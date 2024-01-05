class MeController < ApplicationController
  before_action :verify_access_token

  def show
    render json: {
      user: {
        name: @user.name,
      },
      session: {
        id: @session.id,
      }
    }
  end

  private def verify_access_token
    authorization = request.authorization
    if authorization.nil?
      raise Errors::BadRequest, "Authorization header is missing"
    end

    kind, token = authorization.split(" ", 2)
    if kind.downcase != "bearer"
      raise Errors::BadRequest, "Authorization header must start with Bearer"
    end

    # TODO: Encapsulate token verification and fetching user. These are not controller-like logic
    access_token = AccessToken.verify(token)
    if access_token.nil?
      raise Errors::Unauthorized, "Invalid access token"
    end

    @session = access_token.session
    @user = @session.user
  end
end
