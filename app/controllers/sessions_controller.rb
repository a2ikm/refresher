class SessionsController < ApplicationController
  skip_forgery_protection

  def create
    result = Session.start(params[:name], params[:password])
    render json: result.to_h
  rescue RuntimeError => e
    # TODO: error code should be varied for error kinds of client errors and server errors
    render status: 500, json: { error: e.message }
  end
end
