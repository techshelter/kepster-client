# frozen_string_literal: true

require_relative "lib/kepster/client/version"

Gem::Specification.new do |spec|
  spec.name = "kepster-client"
  spec.version = Kepster::Client::VERSION
  spec.authors = ["yanovitchsky"]
  spec.email = ["yannakoun@gmail.com"]

  spec.summary = "Techshelter Kepster client for ruby"
  spec.description = "The ruby client for the kepster service"
  spec.homepage = "https://kepster.techshelter.dev"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/yanovitchsky"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/techshelter/kepster-client"
  spec.metadata["changelog_uri"] = "https://github.com/techshelter/kepster-client/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "httparty", "~> 0.21.0"
  spec.add_dependency "webmock"
  spec.add_dependency "vcr"
  spec.add_dependency "dotenv"
  spec.add_dependency "rack"
  
  spec.add_development_dependency "faker"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
