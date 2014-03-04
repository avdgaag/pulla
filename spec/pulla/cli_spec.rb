require 'spec_helper'

module Pulla
  describe Cli do
    let(:logger) { double }
    subject { described_class.new(logger) }
    it_should_behave_like 'Commandable'
  end
end
