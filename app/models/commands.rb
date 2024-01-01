module Commands
  class BaseError < StandardError
    def to_h
      { error: message }
    end
  end
end
