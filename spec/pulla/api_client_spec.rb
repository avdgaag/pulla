require 'spec_helper'

module Pulla
  describe ApiClient do
    let(:logger) { double('logger').as_null_object }
    subject      { described_class.new('https://example.com/path', 'foo', 'bar', logger) }

    it 'makes an outgoing GET request to the base URI' do
      request = stub_request(:get, 'https://example.com/path')
        .to_return(body: '{}', status: 200)
      subject.get('/path')
      expect(request).to have_been_requested
    end
  end
end
