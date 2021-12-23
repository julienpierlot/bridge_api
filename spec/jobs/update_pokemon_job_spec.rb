require 'rails_helper'

RSpec.describe UpdatePokemonJob, type: :job do
  describe '#perform' do
    it 'calls .fetch! on Pokemon class' do
      expect(Pokemon).to receive(:fetch!)
      described_class.perform_now
    end
  end
end
