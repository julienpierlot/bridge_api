require 'rails_helper'

RSpec.describe PokemonsFetcher do
  describe '#call' do
    let(:service) { described_class.new }
    let(:body) do
      '{"count":1118,"next":null,"previous":null,"results":[{"name":"bulbasaur","url":"https://pokeapi.co/api/v2/pokemon/1/"}]}'
    end

    before(:each) do
      stub_request(:get, "https://pokeapi.co/api/v2/pokemon/bulbasaur")
        .to_return(status: 200, body: {name: 'bulbasaur'}.to_json)
    end

    it 'calls #find_or_create_from_api! with correct params' do
      stub_request(:get, "https://pokeapi.co/api/v2/pokemon/?limit=20&offset=0")
        .to_return(status: 200, body: body)
      stub_request(:get, "https://pokeapi.co/api/v2/pokemon/bulbasaur")
        .to_return(status: 200, body: {name: 'bulbasaur'}.to_json)
      expect(Pokemon).to receive(:find_or_create_from_api!)
        .with("{\"name\":\"bulbasaur\",\"url\":\"https://pokeapi.co/api/v2/pokemon/bulbasaur\",\"resource_name\":\"pokemon\"}")
      service.call
    end
  end
end
