# frozen_string_literal: true

require 'spec_helper'

describe Awsmeta::Request do
  let(:not_found) { Net::HTTPResponse.new('1.1', 404, 'Not Found') }

  it 'safe json parse will return string if invalid json' do
    test_string = 'i-1u2391rjifw'
    expect(described_class.safe_json_parse(test_string)).to eq(test_string)
  end

  it 'requests that fail will return a hash with an code and error keys' do
    allow(described_class).to receive(:get).and_return(not_found)
    response = described_class.request('test')
    expected = { error: 'Not Found', code: 404 }
    expect(response).equal?(expected)
  end
end
