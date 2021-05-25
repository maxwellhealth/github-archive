# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_archive/version'

Gem::Specification.new do |spec|
  spec.name        = 'github_archive'
  spec.version     = GithubArchive::VERSION
  spec.authors     = ['Brad Clark']
  spec.email       = ['bdashrad@gmail.com']

  spec.summary     = 'Archive github'
  spec.description = 'Download a tarball of the master branch of all repos in' \
                     ' a github orgainization'
  spec.homepage    = "https://github.com/maxwellhealth/github-archive/"
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.2.10'
  spec.add_development_dependency 'pry', '~> 0.10.x'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'octokit', '~> 4.x'
  spec.add_runtime_dependency 'thor', '~> 0.19.x'
end
