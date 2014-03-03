module Pulla
  module Entities
    class Branch
      include JsonEntity

      property :label
      property :ref
      property :sha
    end
  end
end
