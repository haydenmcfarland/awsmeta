# frozen_string_literal: true

require 'spec_helper'

describe Awsmeta::Query do
  let(:not_found) { Net::HTTPResponse.new('1.1', 404, 'Not Found') }

  it 'fetch raises error when a resource is not found' do
    allow(Awsmeta::Request).to receive(:get).and_return(not_found)
    expect { described_class.fetch('test') }
      .to raise_error(Awsmeta::Errors::ResourceNotFound)
  end
end
