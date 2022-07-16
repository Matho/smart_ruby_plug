module SmartRubyPlug
  module Requests
    class SmartPlugBaseRequest
      def initialize
        init_settings
      end

      private

      def init_settings
        ha_node_settings = Config.parsed_settings[:home_assistant_node]
        @home_assistant_host_with_port = ha_node_settings[:host]
        @long_lived_token = ha_node_settings[:long_lived_token]
        @plug_entity_id = ha_node_settings[:smart_plug_entity_id].to_s
      end
    end
  end
end
