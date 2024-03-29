require 'optparse'

module Gemcompat
  class Runner
    attr_reader :options

    def run!(argv = ARGV)
      parse_args!(argv)
      checker = CompatibilityChecker.new(**options.slice(:package_name, :target_version))
      checker.parse_lockfile(lockfile: lockfile_contents)
    end

    def parse_args!(argv = ARGV)
      @options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: gemcompat --package rails --version 7.0 --lockfile ~/path/to/Gemfile.lock"

        opts.on('-p', '--package PACKAGE_NAME', 'Package to check compatibility for') do |pkg|
          @options[:package_name] = pkg
        end

        opts.on('-t', '--target-version VERSION_NUMBER', 'Version to check compatibility for') do |version|
          @options[:target_version] = version
        end

        opts.on('-l', '--lockfile LOCKFILE', 'Path to Gemfile.lock') do |lockfile_path|
          @options[:lockfile_path] = lockfile_path
        end
      end.parse!(argv)

      unless options.include?(:package_name)
        fail "Must pass --package"
      end

      unless options.include?(:target_version)
        fail "Must pass --target-version"
      end

      unless options.include?(:lockfile_path)
        fail "Must pass --lockfile"
      end

      unless lockfile_exists?
        fail "#{options[:lockfile_path]} does not exist"
      end
    end

    private

    def lockfile_exists?
      File.exist?(options[:lockfile_path])
    end

    def lockfile_contents
      File.read(options[:lockfile_path])
    end
  end
end

