require 'rails_helper'

RSpec.describe UpdateSourcesJob, type: :job do
  describe '#perform' do
    let(:sources) { Rails.application.config_for(:sources)['sources'] }

    it 'sends job to update each source' do
      described_class.perform_now
      expect(UpdatePokemonJob).to have_been_enqueued
    end
  end
end
