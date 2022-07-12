require 'net/ping'

module SmartRubyPlug
  module Requests
    class WifiRequest
      def initialize
        antennas_pings = Config.parsed_settings[:ping][:urls][:for_wifi][:antennas]

        @client_endpoints = antennas_pings[:client]
        @provider_endpoints = antennas_pings[:provider]
      end

      # it takes few seconds to execute all pings
      def do_request
        errors = compute_pings(@client_endpoints)

        # do not compute provider pings, if there are some client errors to, because we show only the first found error
        return errors if errors.length > 0

        compute_pings(@provider_endpoints)
      end

      private

      def compute_pings(array_of_hash_to_check)
        errors = []

        array_of_hash_to_check.each do |hash|
          net_ping = Net::Ping::External.new(hash[:url])

          unless net_ping.ping?
            errors = hash
            break
          end
        end

        errors
      end
    end
  end
end
