lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metaconfig/version'

Gem::Specification.new do |spec|
  spec.name = 'metaconfig'
  spec.version = Metaconfig::VERSION
  spec.required_ruby_version = '>= 2.3.0'
  spec.authors = ['Ahmed Al Hafoudh']
  spec.email = ['alhafoudh@freevision.sk']

  spec.summary = %q{Library to handle runtime configuration in local and cloud environments.}
  # spec.description = %q{TODO: Write a longer description or delete this line.}
  spec.homepage = 'https://github.com/alhafoudh/metaconfig'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/alhafoudh/metaconfig'
  spec.metadata['changelog_uri'] = 'https://github.com/alhafoudh/metaconfig/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/alhafoudh/metaconfig/issues'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
