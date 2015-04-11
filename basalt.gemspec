#
# basalt/basalt.gemspec
#
lib = File.expand_path('lib', File.dirname(__FILE__))
$:.unshift lib unless $:.include?(lib)

require 'basalt/version'

Gem::Specification.new do |s|
  s.name        = 'basalt'
  s.summary     = 'Moon Package Manager.'
  s.description = 'A simple package manager, meant for use with moon.'
  s.homepage    = 'https://github.com/IceDragon200/moon-basalt'
  s.email       = 'mistdragon100@gmail.com'
  s.version     = Basalt::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.to_date.to_s
  s.license     = 'MIT'
  s.authors     = ['Corey Powell']

  s.add_dependency 'docopt',        '~> 0.5'
  s.add_dependency 'colorize',      '~> 0.7'
  s.add_dependency 'activesupport', '~> 4.2'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'simplecov', '~> 0'

  s.executables = ['basalt']
  s.require_path = 'lib'
  s.files = []
  s.files += Dir.glob('{lib,spec}/**/*.rb')
end
