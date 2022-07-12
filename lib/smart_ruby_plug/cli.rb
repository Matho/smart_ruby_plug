require "thor"

module SmartRubyPlug
  class Cli < ::Thor
    desc "hello NAME", "say hello to NAME"
    def hello(name)
      puts "Starting the app"

      # pp Config.parsed_settings

      # p SmartRubyPlug::Requests::WifiRequest.new.do_request

      p SmartRubyPlug::Requests::InternetRequest.new.do_request


      # ::MyLibrary.LCD_1in3_test
      # ::MyLibrary.KEY_1in3_test
    end
  end
end