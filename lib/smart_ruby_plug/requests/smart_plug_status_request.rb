module SmartRubyPlug
  module Requests
    class SmartPlugStatusRequest  < SmartPlugBaseRequest
      SUCCESS_API_CODE = 200.freeze
      API_STATUS_PATH = '/api/states/'.freeze

      def do_request
        begin
          response = HTTParty.get(do_request_url,
                                  headers: {
                                    "content-type" => 'application/json',
                                    "Authorization" => "Bearer #{@long_lived_token}"
                                  })
        rescue => e
          return nil
        end

        # request has failed, we dont know if plug is on or off
        return nil unless request_passed?(response)

        begin
          parsed_body = JSON.parse(response.body)
        rescue => e
          return nil
        end

        parsed_body['state']&.to_sym
      end

      def request_passed?(response)
        response.code == SUCCESS_API_CODE
      end

      def do_request_url
        "#{@home_assistant_host_with_port}#{API_STATUS_PATH}#{@plug_entity_id}"
      end
    end
  end
end
