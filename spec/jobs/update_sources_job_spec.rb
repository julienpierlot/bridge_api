require 'rails_helper'

RSpec.describe UpdateSourcesJob, type: :job do
  describe '#perform' do
    let(:sources) { Rails.application.config_for(:sources)['sources'] }

    it 'sends job to update each source' do
      expect(UpdatePokemonJob).to receive(:perform_now)
      described_class.perform_now
    end
  end
end
