# frozen_string_literal: true

require 'spec_helper'

describe StackmapHelper do
  describe '#stackmap_api_url' do
    context 'when LAW' do
      it { expect(stackmap_api_url('LAW')).to match(%r{https://stanfordlaw\.stackmap\.com}) }
    end

    context 'when anyting else' do
      it { expect(stackmap_api_url('GREEN')).to match(%r{https://stanford\.stackmap\.com}) }
    end
  end
end
