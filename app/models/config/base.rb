module Config
  class Base
    pattr_initialize :raw_content

    def serialize(data = content)
      data
    end

    def linter_name
      self.class.name.demodulize.underscore
    end

    private

    attr_implement :parse, [:file_content]

    def content
      @content ||= safe_parse
    end

    def safe_parse
      parse(raw_content || default_content)
    rescue JSON::ParserError, Psych::Exception => exception
      raise_parse_error(exception.message)
    end

    def default_content
      "{}"
    end

    def raise_parse_error(message)
      raise Config::ParserError.new(message, linter_name: linter_name)
    end
  end
end
