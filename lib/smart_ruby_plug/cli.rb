require "thor"

module SmartRubyPlug
  class Cli < ::Thor
    desc 'start', 'start the SmartRubyPlug app'
    def start
      SmartRubyPlug::StdoutLogger.logger.info("Starting SmartRubyPlug with version #{SmartRubyPlug::Version::VERSION} ...")

      SmartRubyPlug::Processor.new.process

      SmartRubyPlug::StdoutLogger.logger.info('Exiting SmartRubyPlug ...')
    end
  end
end