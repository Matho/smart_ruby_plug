RSpec.describe SmartRubyPlug::Requests::SmartPlugOnRequest do
  describe '#do_request' do
    context 'with positive scenario' do
      it 'do request' do
        instance = SmartRubyPlug::Requests::SmartPlugOnRequest.new

        VCR.use_cassette('smart_plug_on') do
          result = instance.do_request
          expect(result).to be_truthy
        end
      end
    end

    context 'with negative scenario' do
      it 'do request' do
        allow_any_instance_of(SmartRubyPlug::Requests::SmartPlugOnRequest).to receive(:do_request_url).and_return('http://localhost')

        instance = SmartRubyPlug::Requests::SmartPlugOnRequest.new

        VCR.use_cassette('smart_plug_on_bad_example') do
          result = instance.do_request
          expect(result).to be_falsey
        end
      end
    end
  end
end