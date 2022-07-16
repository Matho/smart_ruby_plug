RSpec.describe SmartRubyPlug::Requests::InternetRequest do
  describe '#do_request' do
    context 'with negative scenario' do
      it 'do request with failed ping response' do
        allow_any_instance_of(Net::Ping::External).to receive(:ping?).and_return(false)

        instance = SmartRubyPlug::Requests::InternetRequest.new
        result = instance.do_request

        expect(result[:name]).to eq('Starlink')
        expect(result[:url]).not_to eq('')
      end
    end

    context 'with positive scenario' do
      it 'do request with success ping response' do
        allow_any_instance_of(Net::Ping::External).to receive(:ping?).and_return(true)

        instance = SmartRubyPlug::Requests::InternetRequest.new
        result = instance.do_request

        expect(result).to eq([])
      end
    end
  end
end