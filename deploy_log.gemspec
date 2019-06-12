lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "deploy_log/version"

Gem::Specification.new do |spec|
  spec.name          = "deploy_log"
  spec.version       = DeployLog::VERSION
  spec.authors       = ["Ryan Priebe"]
  spec.email         = ["rpriebe@me.com"]

  spec.summary       = "Find out what pull requests are merged within a specific timeframe, or search by PR title or branch name"
  spec.description   = "That's prety much it"
  spec.homepage      = "https://github.com/aapis/deploy_log"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = 'exe/deploy_log'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'notifaction', '~> 0.4.4'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_runtime_dependency 'octokit', '~> 4.0'
end
