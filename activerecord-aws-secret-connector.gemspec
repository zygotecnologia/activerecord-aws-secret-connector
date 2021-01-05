# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/aws_secret_connector/version'

Gem::Specification.new do |spec|
  spec.name          = 'activerecord-aws-secret-connector'
  spec.version       = ActiveRecord::AwsSecretConnector::VERSION
  spec.authors       = ["João Paulo Lethier"]
  spec.email         = ["joaopaulo.lethier@zygotecnologia.com"]
  spec.description   = %q{Adds ability to active record connect to database using aws secret to store database connection informations}
  spec.summary       = %q{Adds ability to active record connect to database using aws secret to store database connection informations}
  spec.homepage      = 'https://github.com/zygotecnologia/activerecord-aws-secret-connector'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-secretsmanager', '~> 1.43.0'
  spec.add_dependency 'activerecord', '~> 6.0.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
