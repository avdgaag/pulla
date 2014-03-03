module Pulla
  module Commandable
    @options_for_next_method = []

    def desc(*args)
      @options_for_next_method = *args
    end

    def method_added(name)
      @available_commands ||= {}
      if defined?(@options_for_next_method) && @options_for_next_method
        @available_commands[name] = @options_for_next_method
        @options_for_next_method = nil
      end
    end

    def add_commands(option_parser, obj)
      Hash(@available_commands).each do |method_name, options|
        option_parser.on(*options, &obj.method(method_name))
      end
    end
  end
end
