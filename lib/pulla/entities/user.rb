module Pulla
  module Entities
    class User
      include JsonEntity

      property :login
      property :site_admin?
      property :html_url,     URI
      property :gravatar_url, URI

      def to_s
        login
      end
    end
  end
end
