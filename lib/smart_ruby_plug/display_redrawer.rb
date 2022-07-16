module SmartRubyPlug
  class DisplayRedrawer
    ON_SCREEN = 1
    OFF_SCREEN = 2
    BOOT_SCREEN = 3
    ERROR_SCREEN = 4
    BLACK_SCREEN = 5

    def initialize
      @ping_interval = Config.parsed_settings[:ping][:interval] # in seconds
      @boot_countdown_timer = Config.parsed_settings[:timers][:boot_countdown_timer] # in seconds
      @plug_name = Config.parsed_settings[:smart_plug][:name]
      @last_status = nil
    end

    def redraw_with_error(message)
      redraw_screen(ERROR_SCREEN, message)
    end

    def redraw_with_status(status)
      case status
      when :on
        redraw_screen(ON_SCREEN)
      when :off
        redraw_screen(OFF_SCREEN)
      when :unavailable
        redraw_screen(ERROR_SCREEN, @plug_name)
      when nil
        redraw_screen(OFF_SCREEN)
      else
        redraw_screen(BLACK_SCREEN)
      end
    end

    def redraw_screen(screen_id, message = nil)
      status_changed = update_last_status(screen_id, message)

      if status_changed
        message_lines = [nil, nil]
        message_lines = message.split(' ') if message

        SmartRubyPlug::StdoutLogger.logger.debug("Redrawing screen with screen_id: #{screen_id} and message_lines: #{message_lines}")
        ::CLibrary.LCD_redraw(screen_id, message_lines[0].to_s, message_lines[1].to_s, @ping_interval, @boot_countdown_timer)
      end

      # do not listen on key pressed on boot screen to do faster redraw from boot to on screen
      return if screen_id == BOOT_SCREEN

      exit_code = ::CLibrary.KEY_listen(@ping_interval)
      key_pressed = (exit_code == 1)

      SmartRubyPlug::StdoutLogger.logger.info("Key was pressed: #{key_pressed}")

      if key_pressed === true
        SmartRubyPlug::Requests::SmartPlugOnRequest.new.do_request
        redraw_screen(BOOT_SCREEN)
      end
    end

    def update_last_status(screen_id, message)
      previous_status = @last_status
      new_status = "#{screen_id}_#{message}"
      @last_status = new_status

      previous_status != new_status
    end
  end
end
