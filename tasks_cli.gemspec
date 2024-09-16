require_relative 'lib/tasks_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "tasks_cli"
  spec.version       = TasksCLI::VERSION
  spec.authors       = ["adilw3nomad"]
  spec.email         = ["adil@w3nomad.com"]

  spec.summary       = %q{A simple CLI for managing tasks}
  spec.description   = %q{A command-line interface for managing tasks stored in a CSV file}
  spec.homepage      = "https://github.com/yourusername/tasks_cli"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/adilw3nomad/tasks_cli"
  spec.metadata["changelog_uri"] = "https://github.com/adilw3nomad/tasks_cli/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.0"
  spec.add_dependency "rainbow", "~> 3.0"
end