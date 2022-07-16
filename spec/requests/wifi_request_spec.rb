RSpec.describe SmartRubyPlug::Requests::WifiRequest do
  describe '#do_request' do
    context 'with negative scenario' do
      it 'do request with failed ping response' do
        allow_any_instance_of(Net::Ping::External).to receive(:ping?).and_return(false)

        instance = SmartRubyPlug::Requests::WifiRequest.new
        result = instance.do_request

        # it returns first client error
        expect(result[:name]).to eq('Wifi 1099')
        expect(result[:url]).to eq('10.0.3.11')
      end
    end

    context 'with positive scenario' do
      it 'do request with failed ping response' do
        allow_any_instance_of(Net::Ping::External).to receive(:ping?).and_return(true)

        instance = SmartRubyPlug::Requests::WifiRequest.new
        result = instance.do_request

        expect(result).to eq([])
      end
    end
  end
end