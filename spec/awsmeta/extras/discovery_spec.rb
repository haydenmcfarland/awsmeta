# frozen_string_literal: true

require 'spec_helper'

describe Awsmeta::Extras::Discovery do
  after(:each) do
    %w[
      AWSMETA_DISABLE_EC2_DISCOVERY
      AWSMETA_OPEN_TIMEOUT
      AWSMETA_OPEN_TIMEOUT
    ].each { |c| ENV.delete(c) }
  end

  it 'can disable discovery when environment variable' do
    ENV['AWSMETA_DISABLE_EC2_DISCOVERY'] = 'true'
    expect(described_class.ec2?).to eq(false)
  end

  it 'will return false on timeout' do
    ENV['AWSMETA_OPEN_TIMEOUT'] = ENV['AWSMETA_READ_TIMEOUT'] = '1'
    expect(described_class.ec2?).to eq(false)
  end
end
