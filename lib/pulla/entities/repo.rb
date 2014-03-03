module Pulla
  module Entities
    class Repo
      include JsonEntity

      property :owner, User
      property :name
      property :full_name
      property :description
      property :private?
      property :fork?
      property :html_url,   URI
      property :clone_url,  URI
      property :git_url,    URI
      property :ssh_url,    URI
      property :svn_url,    URI
      property :mirror_url, URI
      property :homepage
      property :default_branch
      property :master_branch
      property :open_issues_count, Integer
      property :forks_count,       Integer
      property :stargazers_count,  Integer
      property :watchers_count,    Integer
      property :pushed_at,         Time
      property :created_at,        Time
      property :updated_at,        Time
    end
  end
end
