module Pulla
  module Entities
    class Commit
      include JsonEntity

      property :url, URI
      property :sha
      property :author,         Author, at: 'commit.author'
      property :committer,      Author, at: 'commit.committer'
      property :tree,           User,   at: 'commit.tree.sha'
      property :author_user,    User,   at: 'author'
      property :committer_user, User,   at: 'committer'
      property :message, at: 'commit.message'
      property :parents, at: 'parents.sha'
    end
  end
end
