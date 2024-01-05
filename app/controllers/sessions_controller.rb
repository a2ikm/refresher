class SessionsController < ApplicationController
  def create
    raise Errors::BadRequest, "name parameter is not given" if params[:name].nil?
    raise Errors::BadRequest, "password parameter is not given" if params[:password].nil?

    result = ActiveRecord::Base.transaction do
      Commands::StartSession.run(params[:name], params[:password])
    end

    render json: result.to_h
  end

  def refresh
    raise Errors::BadRequest, "token parameter is not given" if params[:token].nil?

    result = ActiveRecord::Base.transaction do
      Commands::RefreshSession.run(params[:token])
    end

    render json: result.to_h
  end
end
