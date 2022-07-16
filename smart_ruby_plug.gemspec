# coding: utf-8
lib = File.expand_path("../lib/", __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require "smart_ruby_plug/version"

Gem::Specification.new do |spec|
  spec.add_dependency 'thor',  '>= 1.2', '< 2'
  spec.add_development_dependency "bundler", ">= 1.0", "< 3"
  spec.authors = ["Martin Markech"]
  spec.description = "SmartRubyPlug is project to monitor your internet connection and turn on the internet on demand"
  spec.email = "martin.markech@matho.sk"
  spec.executables = %w(smart_ruby_plug)
  spec.files = %w(smart_ruby_plug.gemspec) + Dir["*.md", "bin/*", "lib/**/*.rb"]
  spec.homepage = "http://matho.sk/"
  spec.licenses = %w(MIT)
  spec.name = "SmartRubyPlug"
  spec.metadata = {
    "bug_tracker_uri" => "http://matho.sk/",
    "changelog_uri" => "http://matho.sk/",
    "documentation_uri" => "http://matho.sk/",
    "source_code_uri" => "http://matho.sk/",
    "wiki_uri" => "http://matho.sk/",
    "rubygems_mfa_required" => "false",
  }
  spec.require_paths = %w(lib)
  spec.required_ruby_version = ">= 2.0.0"
  spec.required_rubygems_version = ">= 1.3.5"
  spec.summary = spec.description
  spec.version = SmartRubyPlug::Version::VERSION
end