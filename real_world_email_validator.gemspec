Gem::Specification.new do |s|
  s.name        = 'real_world_email_validator'
  s.version     = '0.1.3'
  s.date        = '2019-05-22'
  s.summary     = "Email address validator that real world needs, for ActiveModel 4+."
  s.description = "Basically based on RFC 5322, with some additional validations so it works on almost all variety of systems."
  s.authors     = ["bary822"]
  s.email       = 'hiroto.fukui822@gmail.com'
  s.files       = ["lib/real_world_email_validator.rb"]
  s.homepage    = 'https://github.com/bary822/real_world_email_validator'
  s.license     = 'MIT'

  s.require_paths = ["lib"]

  s.add_runtime_dependency 'activemodel', '~> 3'

  s.add_development_dependency 'rspec'
end
