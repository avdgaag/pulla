module Pulla
  # Make an object behave like an entity based on a set of JSON-values.
  #
  # This entails:
  #
  # * Objects are immutable
  # * Objects with the same set of attributes are considered equal
  # * Objects can define type-casted attributes
  module JsonEntity
    def self.included(base)
      base.extend ClassMethods
      base.prepend InstanceMethods
    end

    # Defines the class methods added to objects when they include the
    # `JsonEntity` module. This adds the `property` macro, which defines reader
    # methods for properties in the object `attributes` attribute, with the
    # option to specify type casting and custom paths to their values.
    module ClassMethods
      # Define a custom attribute reader method.
      #
      # @example Define a simple attribute reader returning a string
      #   property :my_property
      #
      # @example Define a custom type to cast to
      #   property :my_property, Integer
      #
      # @example Get a value from a special key in the `attributes` hash
      #   property :my_property, at: 'keys.my_prop'
      #
      # @param [Symbol] name of the method to define
      # @param [Object] type to cast the value to
      # @param [Hash] options to set custom hash path
      # @ereturn [Object] casted value from `attributes`
      def property(name, *args)
        name = name.to_s
        type, options = parse_arguments(*args)
        path = options.fetch(:at, name)
        if path.end_with?('?')
          define_predicate_method(name, path.chop)
        else
          define_casted_method(name, type, path)
        end
      end

      private

      def define_casted_method(name, type, path)
        define_method name do
          value = fetch(path)
          case type
          when ->(t) { t == Time }
            Time.parse(value)
          when ->(t) { respond_to? t.to_s, :include_all }
            send(type.to_s, value)
          else
            type.send(:new, value)
          end
        end
      end

      def define_predicate_method(name, path)
        define_method name do
          fetch(path) == 'true'
        end
      end

      def parse_arguments(*args)
        if args.size == 2
          type, options = args
        elsif args.size == 1 && args.first.is_a?(Hash)
          type = String
          options = args.first
        elsif args.size == 1 && !args.first.is_a?(Hash)
          type = args.first
          options = {}
        elsif args.size > 2
          raise ArgumentError, 'Expected either 1-3 arguments'
        else
          type = String
          options = {}
        end
        [type, options]
      end
    end

    # Instance methods mixed into object instances. These are meant to be
    # prepended to the object in question, so these methods can use `super` to
    # wrap their originals, as `initialize` does.
    module InstanceMethods
      attr_reader :attributes, :hash
      private :attributes

      def initialize(attributes, *args)
        super(*args)
        @attributes = attributes
        @hash = self.class.hash ^ @attributes.hash
        freeze
      end

      def ==(other)
        hash == other.hash
      end
      alias_method :eql?, :==

      private

      # Recursively fetch values from nested hashes using a dot notation,
      # handling regular keys, nested keys and fetching keys from an array of
      # hashes.
      def fetch(path, set = attributes)
        path.split('.').inject(set) do |output, part|
          if output.is_a?(Hash)
            output.fetch(part)
          elsif output.is_a?(Array)
            output.map { |el| fetch(part, el) }
          else
            raise ArgumentError, "Could not extract #{part.inspect} from #{output.inspect}"
          end
        end
      end
    end
  end
end
