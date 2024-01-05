module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Errors::Base do |e|
      render status: e.status, json: e.to_h
    end

    rescue_from Commands::BaseError do |e|
      case e
      when Commands::Authenticate::Failed
        render status: 401, json: e.to_h
      else
        Rails.logger.error "unexpected error: #{e.class.name}"
        render status: 500, json: { error: "internal server error" }
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
