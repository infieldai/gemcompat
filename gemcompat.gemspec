lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gemcompat/version"

Gem::Specification.new do |spec|
  spec.name          = "gemcompat"
  spec.version       = Gemcompat::VERSION
  spec.authors       = ["Steve Pike"]
  spec.email         = ["steve@infield.ai"]

  spec.summary       = %q{Check your app for silent incompatibilities with new gem versions}
  spec.description   = %q{Not all gem incompatibilities get reported in gemspecs. This project documents them so you can check ahead of an upgrade.}
  spec.homepage     = "https://github.com/infieldai/gemcompat"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.16", "< 3.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
