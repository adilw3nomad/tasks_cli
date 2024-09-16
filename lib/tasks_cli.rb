# frozen_string_literal: true

require 'tasks_cli/version'
require 'tasks_cli/cli'
require 'tasks_cli/task'
require 'tasks_cli/task_manager'
require 'logger'

module TasksCLI
  class Error < StandardError; end

  # Configuration
  @config = {
    csv_path: File.expand_path('~/tasks.csv'),
    date_format: '%Y-%m-%d %H:%M:%S'
  }

  class << self
    attr_accessor :config

    def configure
      yield(config) if block_given?
    end
  end

  # Utility methods
  def self.format_date(date)
    date.strftime(config[:date_format])
  end

  def self.parse_date(date_string)
    DateTime.strptime(date_string, config[:date_format])
  end

  # Version information
  def self.version
    VERSION
  end

  # Logging
  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = 'TasksCLI'
    end
  end
end
