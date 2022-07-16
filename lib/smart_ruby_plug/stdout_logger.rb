require 'logger'

module SmartRubyPlug
  class StdoutLogger
    @@logger = Logger.new(STDOUT)

    def self.logger
      @@logger
    end
  end
end
