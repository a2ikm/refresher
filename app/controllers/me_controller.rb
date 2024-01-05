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
      render json: { error: "Authorization header is missing" }, status: 401
      return
    end

    kind, token = authorization.split(" ", 2)
    if kind.downcase != "bearer"
      render json: { error: "Authorization header must start with Bearer" }, status: 401
      return
    end

    # TODO: Encapsulate token verification and fetching user. These are not controller-like logic
    access_token = AccessToken.verify(token)
    if access_token.nil?
      render json: { error: "Invalid access token" }, status: 401
      return
    end

    @session = access_token.session
    @user = @session.user
  end
end
