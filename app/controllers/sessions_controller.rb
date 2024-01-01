class SessionsController < ApplicationController
  skip_forgery_protection

  def create
    raise Errors::BadRequest, "name parameter is not given" if params[:name].nil?
    raise Errors::BadRequest, "password parameter is not given" if params[:password].nil?

    result = ActiveRecord::Base.transaction do
      Session.start(params[:name], params[:password])
    end

    render json: result.to_h
  rescue RuntimeError => e
    # TODO: error code should be varied for error kinds of client errors and server errors
    render status: 500, json: { error: e.message }
  end
end
