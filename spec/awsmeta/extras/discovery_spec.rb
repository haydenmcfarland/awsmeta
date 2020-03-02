# frozen_string_literal: true

require 'spec_helper'

describe Awsmeta::Extras::Discovery do
  after(:each) do
    ENV.delete('AWSMETA_DISABLE_EC2_DISCOVERY')
  end

  it 'can disable discovery when environment variable' do
    ENV['AWSMETA_DISABLE_EC2_DISCOVERY'] = 'true'
    expect(described_class.ec2?).to eq(false)
  end

  it 'will return false on timeout' do
    expect(described_class.ec2?).to eq(false)
  end
end
