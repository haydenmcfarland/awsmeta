# frozen_string_literal: true

require 'spec_helper'

describe Awsmeta::Helpers::Hash do
  it 'symobilizes and underscores camleized hash keys' do
    hash = {
      'BananaPanic' => nil,
      'Banana::Panic' => 'a',
      'BananaPanicPanic' => 'b',
      nil => 'c'
    }

    result = described_class.symbolize_and_underscore_keys(hash)

    expected = {
      banana_panic: nil,
      :"banana/panic" => 'a',
      banana_panic_panic: 'b',
      nil => 'c'
    }

    expect(result).to eq(expected)
  end
end
