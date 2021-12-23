require 'rails_helper'

RSpec.describe "Api::V1::Pokemons", type: :request do
  describe "#index" do
    let(:params) { { format: :json } }
    let(:get_request) { get '/api/v1/pokemons', params: params }
    let!(:pokemon) { FactoryBot.create(:pokemon, :with_type) }

    it 'returns correct pokemon data' do
      get_request
      result = {
        count: Pokemon.count,
        offset: 0,
        previous_url: nil,
        next_url: nil,
        pokemons: [
          {
            id: pokemon.id,
            name: pokemon.name,
            types: pokemon.types.map do |type|
              { name: type.name }
            end
          },
        ]
      }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(result.to_json)
    end

    context 'when there are 2 pokemons' do
      let!(:pokemon_2) { FactoryBot.create(:pokemon, :with_type) }

      context 'when limit is set to 1' do
        let(:params) { { format: :json, limit: 1 } }

        it 'returns 1 pokemon' do
          get_request
          result = {
            count: Pokemon.count,
            offset: 0,
            previous_url: nil,
            next_url: api_v1_pokemons_url(limit: 1, offset: 1),
            pokemons: [
              {
                id: pokemon.id,
                name: pokemon.name,
                types: pokemon.types.map do |type|
                  { name: type.name }
                end,
              }
            ]
          }
          expect(response.body).to eq(result.to_json)
        end

        context 'when requesting offset 1' do
          let(:params) { { format: :json, limit: 1, offset: 1 } }

          it 'returns 1 pokemon' do
            get_request
            result = {
              count: Pokemon.count,
              offset: 1,
              previous_url: api_v1_pokemons_url(limit: 1, offset: 0),
              next_url: nil,
              pokemons: [
                {
                  id: pokemon_2.id,
                  name: pokemon_2.name,
                  types: pokemon_2.types.map do |type|
                    { name: type.name }
                  end,
                }
              ]
            }
            expect(response.body).to eq(result.to_json)
          end
        end
      end
    end
  end

  describe "#show" do
    let(:params) { { format: :json } }
    let!(:pokemon) { FactoryBot.create(:pokemon, :with_type) }
    let(:name) { CGI.escape(pokemon.name) }
    let(:get_request) { get "/api/v1/pokemons/#{name}", params: params }

    it 'returns correct pokemon data' do
      get_request
      result = {
        id: pokemon.id,
        name: pokemon.name,
        base_experience: pokemon.base_experience,
        height: pokemon.height,
        weight: pokemon.weight,
        types: pokemon.types.map do |type|
          { name: type.name }
        end
      }
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(result.to_json)
    end

    context 'when name is capitalized' do
      let(:name) { CGI.escape(pokemon.name.capitalize) }

      it 'returns a 200' do
        get_request
        expect(response).to have_http_status(:success)
      end
    end
  end

end
