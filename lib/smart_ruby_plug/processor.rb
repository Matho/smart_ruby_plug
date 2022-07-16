module SmartRubyPlug
  class Processor
    def initialize
      @ping_interval = Config.parsed_settings[:ping][:interval] # in seconds
      @check_wifi = Config.parsed_settings[:ping][:check_wifi]
      @check_internet = Config.parsed_settings[:ping][:check_internet]
      @display_redrawer = DisplayRedrawer.new
    end

    def process
      while true do
        SmartRubyPlug::StdoutLogger.logger.debug('Running processor with ping checks ...')

        smart_plug_status = smart_plug_check

        # if the smart plug is on or off, then redraw status
        unless smart_plug_status.nil?
          SmartRubyPlug::StdoutLogger.logger.debug("Smart Plug status: '#{smart_plug_status}'")

          redraw_display_with_status(smart_plug_status)
          next
        end

        # when unable to detect smart plug status, the wifi or internet is down. Detect which one and show error
        if @check_wifi
          @wifi_output = wifi_check
          unless @wifi_output == []
            redraw_display_with_error(@wifi_output)
            return
          end
        end

        if @check_internet
          @internet_output = internet_check
          unless @internet_output == []
            redraw_display_with_error(@internet_output)
            return
          end
        end
      end
    end

    private

    def redraw_display_with_error(hash)
      @display_redrawer.redraw_with_error(hash[:name])
    end

    # :on, :off, :unavailable or nil
    def redraw_display_with_status(status)
      @display_redrawer.redraw_with_status(status)
    end

    def wifi_check
      SmartRubyPlug::StdoutLogger.logger.info("Wifi nodes ping check ...")
      SmartRubyPlug::Requests::WifiRequest.new.do_request
    end

    def internet_check
      SmartRubyPlug::StdoutLogger.logger.info("Internet ping check ...")
      SmartRubyPlug::Requests::InternetRequest.new.do_request
    end

    def smart_plug_check
      SmartRubyPlug::StdoutLogger.logger.info("Smart Plug ping check ...")
      SmartRubyPlug::Requests::SmartPlugStatusRequest.new.do_request
    end
  end
end
