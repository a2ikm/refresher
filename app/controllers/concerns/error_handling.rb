module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Errors::Base do |e|
      render status: e.status, json: e.to_h
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
  end
end
