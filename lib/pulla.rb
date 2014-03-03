require 'time'
require 'uri'
require 'delegate'
require 'json'
require 'net/http'
require 'yaml/store'
require 'logger'
require 'optparse'

require 'pulla/version'
require 'pulla/commandable'
require 'pulla/cli'
require 'pulla/api_caching'
require 'pulla/json_api'
require 'pulla/api_client'
require 'pulla/github_client'
require 'pulla/json_entity'
require 'pulla/entities/author'
require 'pulla/entities/branch'
require 'pulla/entities/user'
require 'pulla/entities/comment'
require 'pulla/entities/commit'
require 'pulla/entities/repo'
require 'pulla/entities/pull_request'
require 'pulla/entities/review_comment'

module Pulla
  def self.start(cli_args = [])
    Cli.new(default_logger).run(cli_args)
  end

  def self.default_logger
    @default_logger = Logger.new(STDOUT).tap do |logger|
      logger.level = Logger::WARN
    end
  end
end
