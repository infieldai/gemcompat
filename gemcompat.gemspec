# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemcompat/version'

Gem::Specification.new do |spec|
  spec.name          = 'gemcompat'
  spec.version       = Gemcompat::VERSION
  spec.authors       = ['Steve Pike']
  spec.email         = ['steve@infield.ai']

  spec.summary       = 'Check your app for silent incompatibilities with new gem versions'
  spec.description   = 'Not all gem incompatibilities get reported in gemspecs. This project documents them so you can check ahead of an upgrade.'
  spec.homepage = 'https://github.com/infieldai/gemcompat'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.3'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'
end
