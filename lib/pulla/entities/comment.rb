module Pulla
  module Entities
    class Comment
      include JsonEntity

      property :body
      property :html_url,   URI
      property :user,       User
      property :created_at, Time
      property :updated_at, Time
    end
  end
end
