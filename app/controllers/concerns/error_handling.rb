module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Errors::Base do |e|
      render status: e.status, json: e.to_h
    end

    around_action :translate_command_error_to_controller_error
  end

  private def translate_command_error_to_controller_error
    begin
      yield
    rescue Commands::BaseError => e
      case e
      when Commands::Authenticate::Failed, Commands::RefreshSession::Failed
        raise Errors::Unauthorized, e.message
      else
        Rails.logger.error "unexpected error: #{e.class.name}"
        raise e.message
      end
    end
  end

  module Errors
    class Base < StandardError
      def to_h
        { error: message }
      end

      def status
        raise NotImplementedError
      end
    end

    class BadRequest < Base
      def status; 400; end
    end

    class Unauthorized < Base
      def status; 401; end
    end
  end
end
