# frozen_string_literal: true

module Gemcompat
  # Check a lockfile for compatibility
  class CompatibilityChecker
    attr_reader :package_incompatibilities, :package_name, :target_version, :found_incompatibilities

    def initialize(package_name:, target_version:)
      @package_name = package_name
      @target_version = target_version
      load_package_data!(package_name: package_name, target_version: target_version)
    end

    def welcome(package_name:, target_version:)
      puts "Checking for undocumented incompatibilities with #{package_name} v#{target_version}\n\n"
    end

    def package_version_to_path_part(version)
      version&.gsub('.', '_')
    end

    def incompatibility_datafile(package_name:, target_version:)
      "data/#{package_name}/#{package_version_to_path_part(target_version)}.yaml"
    end

    def load_package_data!(package_name:, target_version:)
      path = incompatibility_datafile(package_name: package_name, target_version: target_version)
      @package_incompatibilities = YAML.load_file(path).then do |data|
        data.transform_values { |entry| Gem::Version.new(entry[:first_compatible_version]) }
      end
    rescue Errno::ENOENT
      puts "#{package_name} v#{target_version} not supported yet"
      exit(1)
    end

    def report(found_incompatibilities: @found_incompatibilities)
      welcome(package_name: package_name, target_version: target_version)

      if found_incompatibilities.empty?
        puts 'No incompatibilities found'
      else
        found_incompatibilities.each do |i|
          puts "#{i[:name]}: Using #{i[:using_version]}. Upgrade to #{i[:required_version]}"
        end
      end
    end

    def parse_lockfile!(lockfile:)
      @found_incompatibilities = []
      Bundler::LockfileParser.new(lockfile).specs.each do |spec|
        next unless (required_version = package_incompatibilities[spec.name]) && required_version > spec.version

        found_incompatibilities << {
          name: spec.name,
          using_version: spec.version.to_s,
          required_version: required_version.to_s,
        }
      end
    end
  end
end
