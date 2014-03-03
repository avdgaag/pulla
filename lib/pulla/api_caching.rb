module Pulla
  module ApiCaching
    def get(path, headers = {})
      if cache[path]
        logger.debug('ApiCaching') { "Cache hit for #{path.inspect}; adding conditional headers"  }
        logger.debug('ApiCaching') { "Cache contents: #{cache[path].class}" }
        response = super(path, headers.merge(
          'If-Modified-Since' => cache[path]['Last-Modified'],
          'If-None-Match'     => cache[path]['Etag']
        ))
        if response.is_a? Net::HTTPNotModified
          logger.debug('ApiCaching') { "Not modified #{path.inspect}, returning cache"  }
          cache[path]
        else
          logger.debug('ApiCaching') { "Modified #{path.inspect}, refreshing cache"  }
          cache[path] = response
        end
      else
        logger.debug('ApiCaching') { "Cache miss for #{path.inspect}"  }
        response = super
        logger.debug('ApiCaching') { "Cache for #{path.inspect} set to #{response.inspect}"  }
        cache[path] = response
      end
    end

    private

    class YamlCache
      attr_reader :store

      def initialize(filename)
        @store = YAML::Store.new(filename)
      end

      def [](key)
        store.transaction do
          store[key]
        end
      end

      def []=(key, value)
        store.transaction do
          store[key] = value
        end
      end
    end

    def cache
      @cache ||= YamlCache.new('cache.yml')
    end
  end
end
