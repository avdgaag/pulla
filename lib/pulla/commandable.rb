module Pulla
  # Provide a macro to any class to transform regular methods into command line
  # options. By using the `desc` method, the next method you define will be a
  # handler for a command line option described by the arguments to `desc`.
  #
  # Options for the command line argument switch are handled by `OptionParser`
  # from the Ruby standard library.
  #
  # @example Making a method a command-line switch
  #   class CommandLineClient
  #     extend Commandable
  #
  #     def initialize
  #       @options = OptionParser.new
  #       self.class.add_commands(@options, self)
  #     end
  #
  #     desc '-l', '--list', 'Command line switch description'
  #     def list(enabled = true)
  #       # handle switch here
  #     end
  #   end
  #
  # @see OptionParser
  # @see Cli
  module Commandable
    @options_for_next_method = []

    # Make the next method added to this object a handler for a command line
    # option switch and use any arguments for its configuration.
    #
    # @see OptionParser#on
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

    # After all methods have been added, use `add_commands` to collect
    # them all and apply them to an `OptionParser` object.
    #
    # @param [OptionParser, #on] option_parser
    # @param [Object] obj to call the recorded methods on
    def add_commands(option_parser, obj)
      Hash(@available_commands).each do |method_name, options|
        option_parser.on(*options, &obj.method(method_name))
      end
    end
  end
end
