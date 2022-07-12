require_relative "smart_ruby_plug/base"

class Main
  def start(given_args = ARGV, config = {})
    ::SmartRubyPlug::Cli.start(ARGV)
  end
end

