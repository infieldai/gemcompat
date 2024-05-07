# frozen_string_literal: true

require 'optparse'

module Gemcompat
  # This class is the entrypoint for the gem. Initialized from ARGV.
  class Runner
    attr_reader :options

    def run!(argv = ARGV)
      parse_args!(argv)
      checker = CompatibilityChecker.new(**options.slice(:package_name, :target_version))
      checker.parse_lockfile!(lockfile: lockfile_contents)
      checker.report
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def parse_args!(argv = ARGV)
      @options = { lockfile_path: 'Gemfile.lock' }

      argv << '-h' if argv.empty?
      OptionParser.new do |opts|
        opts.banner = 'Usage: gemcompat --package rails --target-version 7.0 --lockfile ~/path/to/Gemfile.lock'

        opts.on('-p', '--package PACKAGE_NAME', 'Package to check compatibility for') do |pkg|
          @options[:package_name] = pkg
        end

        opts.on('-t', '--target-version VERSION_NUMBER', 'Version to check compatibility for') do |version|
          @options[:target_version] = version
        end

        opts.on('-l', '--lockfile LOCKFILE', 'Path to Gemfile.lock') do |lockfile_path|
          @options[:lockfile_path] = lockfile_path
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end.parse!(argv)

      validate_args!
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private

    def fail_with(msg)
      puts msg
      exit(1)
    end

    def validate_args!
      fail_with 'Must pass --package' unless options.include?(:package_name)

      fail_with 'Must pass --target-version' unless options.include?(:target_version)

      fail_with 'Must pass --lockfile' unless options.include?(:lockfile_path)

      return if lockfile_exists?

      fail_with "#{options[:lockfile_path]} does not exist"
    end

    def lockfile_exists?
      File.exist?(options[:lockfile_path])
    end

    def lockfile_contents
      File.read(options[:lockfile_path])
    end
  end
end
