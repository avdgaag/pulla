module Pulla
  module JsonEntity
    def self.included(base)
      base.extend ClassMethods
      base.prepend InstanceMethods
    end

    module ClassMethods
      def property(name, type = String, options = {})
        name = name.to_s
        path = options.fetch(:at, name)
        if path.end_with?('?')
          define_method name do
            fetch(path.chop) == 'true'
          end
        else
          define_method name do
            value = fetch(path)
            case type
            when Time
              Time.parse(value)
            when ->(t) { respond_to? t.to_s, :include_all }
              send(type.to_s, value)
            else
              type.send(:new, value)
            end
          end
        end
      end
    end

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

      def fetch(path, set = attributes)
        path.split('.').inject(set) do |output, part|
          if output.is_a?(Hash)
            output.fetch(part)
          elsif output.is_a?(Array)
            output.map { |el| jpath(part, el) }
          else
            raise ArgumentError, "Could not extract #{part.inspect} from #{output.inspect}"
          end
        end
      end
    end
  end
end
