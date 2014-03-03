module Pulla
  module Entities
    class PullRequest
      include JsonEntity

      property :title
      property :number, Integer
      property :body
      property :html_url,   URI
      property :created_at, Time
      property :updated_at, Time
      property :merged_at,  Time
      property :closed_at,  Time
      property :user,       User
      property :head,       Branch
      property :base,       Branch
      property :repo,       Repo
      property :state
      property :mergeable?
      property :merged?
      property :comments_count, Integer, at: 'comments'
      property :commits_count,  Integer, at: 'commits'
      property :additions,      Integer
      property :deletions,      Integer
      property :changed_files,  Integer

      attr_reader :client
      private :client

      def initialize(client)
        @client = client
      end

      def commits
        client.pull_request_commits(self)
      end

      def comments
        (
          client.pull_request_comments(self) +
          client.pull_request_review_comments(self)
        ).sort_by(&:created_at)
      end
    end
  end
end
