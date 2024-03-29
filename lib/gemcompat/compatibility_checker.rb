module Gemcompat
  class CompatibilityChecker
    attr_reader :package_incompatibilities

    def initialize(package_name:, target_version:)
      load_package_data!(package_name:, target_version:)
      welcome(package_name:, target_version:)
    end

    def welcome(package_name:, target_version:)
      puts "Checking for undocumented incompatibilities with #{package_name} v#{target_version}\n\n"
    end

    def package_version_to_path_part(version)
      version&.gsub('.', '_')
    end

    def incompatibility_datafile(package_name:, target_version:)
      File.open("data/#{package_name}/#{package_version_to_path_part(target_version)}.yaml")
    end

    def load_package_data!(package_name:, target_version:)
      @package_incompatibilities = YAML.load(incompatibility_datafile(package_name:, target_version:))
                                     .map { |(name, h)| [name, Gem::Version.new(h[:first_compatible_version])] }
                                     .to_h
    end

    def parse_lockfile(lockfile:)
      Bundler::LockfileParser.new(lockfile).specs.each do |spec|
        name = spec.name
        next unless required_version = package_incompatibilities[name]
        if required_version > spec.version
          puts "#{name}: Using #{spec.version}. Upgrade to #{required_version}"
        end
      end
    end
  end
end
