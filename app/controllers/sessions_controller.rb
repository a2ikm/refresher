class SessionsController < ApplicationController
  skip_forgery_protection

  def create
    raise Errors::BadRequest, "name parameter is not given" if params[:name].nil?
    raise Errors::BadRequest, "password parameter is not given" if params[:password].nil?

    result = ActiveRecord::Base.transaction do
      Commands::StartSession.run(params[:name], params[:password])
    end

    render json: result.to_h
  end
end
