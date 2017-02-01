$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "exporter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "exporter"
  s.version     = Exporter::VERSION
  s.authors     = ["Amruthesh G"]
  s.email       = ["amruthesh.g@jifflenow.com"]
  s.homepage    = "http://localhost:3000"
  s.summary     = "Summary of Exporter."
  s.description = "Description of Exporter."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", '4.2.5.1'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'pry-remote'
  s.add_dependency 'sqlite3'
end
