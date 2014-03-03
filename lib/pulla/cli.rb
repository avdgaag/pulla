module Pulla
  class Cli
    extend Commandable

    attr_reader :options, :logger

    def initialize(logger)
      @logger = logger
      @options = OptionParser.new do |o|
        o.banner = 'Usage: gpr [options]'
        o.separator ''
        o.separator 'Available options:'
      end
      self.class.add_commands(@options, self)
    end

    def run(arguments)
      options.parse(arguments)
    end

    private

    def api
      @api ||= GithubClient.new github_repo, github_id, github_token, logger
    end

    def github_repo
      @github_repo ||= 'avdgaag/rpub'
    end

    def github_id
      ENV.fetch('GITHUB_ID')
    end

    def github_token
      ENV.fetch('GITHUB_TOKEN')
    end

    desc '-l', '--list', 'List all pull requests in this project'
    def list(enabled)
      pull_requests = api.pulls
      columns = %i[number title user comments_count state mergeable?]
      fmt = columns.map do |column|
        "%#{pull_requests.map { |pr| pr.send(column).to_s.size }.max}s  "
      end.join
      pull_requests.each do |pr|
        printf fmt + "\n", *columns.map { |c| pr.send(c) }
      end
    end

    desc '-c', '--commits NUMBER', Integer, 'Show the commits in pull request NUMBER'
    def commits(number)
      pr = api.pull(number)
      pr.commits.each do |commit|
        puts "#{commit.sha}  #{commit.author.name}  #{commit.author.date.strftime('%Y-%m-%d %H:%m')}"
      end
    end

    desc '-d', '--discussion NUMBER', Integer, 'Show comments on pull request NUMBER'
    def discussion(number)
      pr = api.pull(number)
      pr.comments.each do |comment|
        puts "#{comment.user} on #{comment.created_at.strftime('%Y-%m-%d %H:%m')}:"
        puts comment.body
        puts
      end
    end

    desc '-s', '--show NUMBER', Integer, 'Show detailed information on pull request NUMBER'
    def show(number)
      pr = api.pull(number)
      puts "##{pr.number}: #{pr.title} (#{pr.state}, #{pr.mergeable? ? 'mergeable' : 'not mergeable'})"
      puts "By #{pr.user} on #{pr.created_at.strftime('%Y-%m-%d %H:%m')}"
      puts
      puts pr.body
    end

    desc '-v', 'Enable verbose logging'
    def verbose(enabled)
      logger.level = Logger::DEBUG
    end

    desc '-h', '--help', 'Show this help message'
    def help(enabled)
      puts options
    end

    desc '--version', 'Display the version number'
    def version(enabled)
      puts VERSION
    end

    desc '-r', '--repository NAME', 'Set the Github repository to operate on'
    def repository(name)
      @github_repo = name
    end
  end
end
