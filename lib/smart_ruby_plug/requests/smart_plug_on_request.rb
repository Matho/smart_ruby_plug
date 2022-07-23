module SmartRubyPlug
  module Requests
    class SmartPlugOnRequest < SmartPlugBaseRequest
      API_TURN_ON_PATH = '/api/services/switch/turn_on'.freeze
      SUCCESS_API_CODE = 200.freeze
      SUCCESS_API_MESSAGE = 'OK'.freeze

      def do_request
        begin
          response = HTTParty.post(do_request_url,
                                   body: {
                                     "entity_id": @plug_entity_id
                                   }.to_json,
                                   headers: {
                                     "content-type" => 'application/json',
                                     "Authorization" => "Bearer #{@long_lived_token}"
                                   })
        rescue => e
          return false
        end

        response.code == SUCCESS_API_CODE && response.message == SUCCESS_API_MESSAGE
      end

      def do_request_url
        "#{@home_assistant_host_with_port}#{API_TURN_ON_PATH}"
      end
    end
  end
end
