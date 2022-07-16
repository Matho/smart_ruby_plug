module SmartRubyPlug
  module Requests
    class InternetRequest
      def initialize
        @internet_ping_urls_array = Config.parsed_settings[:ping][:urls][:for_internet]
        @internet_provider_name = Config.parsed_settings[:internet_provider][:name]
      end

      def do_request
        compute_ping
      end

      private

      def compute_ping
        url = random_internet_ping_provider
        net_ping = Net::Ping::External.new(url)

        if net_ping.ping?
          []
        else
          SmartRubyPlug::StdoutLogger.logger.info("Internet ping - failed ping for '#{@internet_provider_name}'")

          {
            url: url,
            name: @internet_provider_name
          }
        end
      end

      def random_internet_ping_provider
        @internet_ping_urls_array.sample
      end
    end
  end
end
