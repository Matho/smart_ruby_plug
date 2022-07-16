RSpec.describe SmartRubyPlug::Requests::SmartPlugStatusRequest do
  describe '#do_request' do
    context 'with positive scenario' do
      context 'when is turned on' do
        it 'works' do
          instance = SmartRubyPlug::Requests::SmartPlugStatusRequest.new

          VCR.use_cassette('smart_plug_status_on') do
            result = instance.do_request

            expect(result).to eq(:on)
          end
        end
      end

      context 'when is turned off' do
        it 'works' do
          instance = SmartRubyPlug::Requests::SmartPlugStatusRequest.new

          VCR.use_cassette('smart_plug_status_off') do
            result = instance.do_request

            expect(result).to eq(:off)
          end
        end
      end
    end

    context 'with negative scenario' do
      context 'with failed url' do
        it 'do request and return nil' do
          allow_any_instance_of(SmartRubyPlug::Requests::SmartPlugStatusRequest).to receive(:do_request_url).and_return('http://localhost')

          instance = SmartRubyPlug::Requests::SmartPlugStatusRequest.new

          VCR.use_cassette('smart_plug_status_bad_url') do
            result = instance.do_request

            expect(result).to be(nil)
          end
        end
      end
    end
  end
end