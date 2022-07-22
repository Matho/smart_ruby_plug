# Encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require "smart_ruby_plug/version"

Gem::Specification.new do |spec|
  spec.add_dependency 'thor',  '>= 1.2', '< 2'
  spec.add_development_dependency "bundler", ">= 1.0", "< 3"
  spec.authors = ["Martin Markech"]
  spec.description = "Smart Ruby Plug is project to monitor your internet connection and turn on the internet on demand"
  spec.email = "martin.markech@matho.sk"
  spec.files = %w(smart_ruby_plug.gemspec) + Dir["*.md", "bin/*", "lib/**/*.rb"]
  spec.homepage = "https://github.com/Matho/smart_ruby_plug"
  spec.licenses = %w(MIT)
  spec.name = "SmartRubyPlug"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/Matho/smart_ruby_plug",
    "changelog_uri" => "https://github.com/Matho/smart_ruby_plug/blob/master/Changelog.md",
    "documentation_uri" => "https://github.com/Matho/smart_ruby_plug/blob/master/README.md",
    "source_code_uri" => "https://github.com/Matho/smart_ruby_plug",
    "wiki_uri" => "https://github.com/Matho/smart_ruby_plug",
    "rubygems_mfa_required" => "false",
  }
  spec.require_paths = %w(lib)
  spec.required_ruby_version = ">= 2.0.0"
  spec.required_rubygems_version = ">= 1.3.5"
  spec.summary = spec.description
  spec.version = SmartRubyPlug::Version::VERSION
end