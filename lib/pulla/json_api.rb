module Pulla
  module JsonApi
    def get(*args)
      logger.debug('JsonApi') { 'Parsing JSON' }
      JSON.parse(super.body)
    end
  end
end
