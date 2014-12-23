#
# basalt/basalt.gemspec
#
lib = File.expand_path('lib', File.dirname(__FILE__))
$:.unshift lib unless $:.include?(lib)

require 'basalt/version'

Gem::Specification.new do |s|
  s.name        = "basalt"
  s.summary     = 'Moon Project Manager'
  s.description = 'Moon Project Manager app'
  s.homepage    = 'https://github.com/IceDragon200/basalt'
  s.email       = 'mistdragon100@gmail.com'
  s.version     = Basalt::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.to_date.to_s
  s.license     = 'MIT'
  s.authors     = ['Corey Powell']

  s.add_dependency 'docopt'
  s.add_dependency 'colorize'

  s.executables = ["basalt"]
  s.require_path = 'lib'
  s.files = []
  s.files += Dir.glob('bin/**/*')
  s.files += Dir.glob('lib/**/*')
  s.files += Dir.glob('spec/**/*')
end
