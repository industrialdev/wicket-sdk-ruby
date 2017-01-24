# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wicket-sdk/version'

Gem::Specification.new do |spec|
  spec.name          = 'wicket-sdk'
  spec.version       = WicketSDK::VERSION
  spec.authors       = ['Terry Appleby']
  spec.email         = ['tappleby@industrialagency.ca']

  spec.summary       = 'A Ruby library for the Wicket Core API. https://wicket.io/technology'
  spec.description   = 'A Ruby library for the Wicket Core API. https://wicket.io/technology'
  spec.homepage      = 'https://github.com/industrialdev/wicket-sdk-ruby'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "http://localhost"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', ['~> 0.9', '< 1.0']
  spec.add_dependency 'jsonapi-parser', '~> 0.1'
  
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'jwt', '~> 1.5'

  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'webmock', '~> 2.3'
end
