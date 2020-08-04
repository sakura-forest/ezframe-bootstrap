
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ezframe/bootstrap/version"

Gem::Specification.new do |spec|
  spec.name          = "ezframe-bootstrap"
  spec.version       = Ezframe::Bootstrap::VERSION
  spec.authors       = ["KAMACHI Masayuki"]
  spec.email         = ["mkamachi@gmail.com"]

  spec.summary       = %q{ezframe用bootstrapライブラリ}
  spec.description   = %q{ezframe用bootstrapライブラリ}
  spec.homepage      = "http://github.com/sakura-forest/ezframe-bootstrap"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ezframe", "~> 0.4"
  spec.add_development_dependency "bundler", "~> 1.16"
  #spec.add_development_dependency "rake", "~> 14.0"
  # spec.add_development_dependency "rspec", "~> 3.0"
end
