module Pulla
  class GithubClient < DelegateClass(ApiClient)
    API_BASE_URI = 'https://api.github.com'.freeze

    def initialize(repo, *args)
      super ApiClient.new(URI.join(API_BASE_URI, 'repos/', repo + '/'), *args)
    end

    def pulls
      get('pulls').map do |p|
        pull(p['number'])
      end
    end

    def pull(number)
      Entities::PullRequest.new(get("pulls/#{number}"), self)
    end

    def pull_request_comments(pull_request)
      get("issues/#{pull_request.number}/comments").map do |c|
        Entities::Comment.new(c)
      end
    end

    def pull_request_commits(pull_request)
      get("pulls/#{pull_request.number}/commits").map do |c|
        Entities::Commit.new(c)
      end
    end

    def pull_request_review_comments(pull_request)
      get("pulls/#{pull_request.number}/comments").map do |c|
        Entities::ReviewComment.new(c)
      end
    end
  end
end
