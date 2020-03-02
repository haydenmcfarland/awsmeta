# frozen_string_literal: true

require 'spec_helper'

describe Awsmeta::Config do
  after(:each) do
    ENV.delete('AWSMETA_OPEN_TIMEOUT')
    ENV.delete('AWSMETA_READ_TIMEOUT')
  end

  it 'environment variable can impact read_timeout' do
    expect(described_class.open_timeout).to eq(10)
    ENV['AWSMETA_READ_TIMEOUT'] = '1'
    expect(described_class.read_timeout).to eq(1)
  end

  it 'environment variable can impact open_timeout' do
    expect(described_class.open_timeout).to eq(10)
    ENV['AWSMETA_OPEN_TIMEOUT'] = '1'
    expect(described_class.open_timeout).to eq(1)
  end
end
