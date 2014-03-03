module Pulla
  module Entities
    class ReviewComment
      include JsonEntity

      property :diff_hunk
      property :path
      property :commit_id
      property :original_commit_id
      property :body
      property :position,          Integer
      property :original_position, Integer
      property :user,              User
      property :created_at,        Time
      property :updated_at,        Time
      property :html_url,          URI
      property :pull_request_url,  URI
    end
  end
end
