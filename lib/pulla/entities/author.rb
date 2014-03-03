module Pulla
  module Entities
    class Author
      include JsonEntity

      property :name
      property :email
      property :date, Time
    end
  end
end
