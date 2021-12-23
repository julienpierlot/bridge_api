require 'rails_helper'

RSpec.describe "Api::V1::Pokemons", type: :request do
  describe "#index" do
    path '/api/v1/pokemons' do
      get 'paginated pokemons' do
        let!(:pokemon) { FactoryBot.create(:pokemon, :with_type) }
        let(:limit) { 20 }
        let(:offset) { 0 }

        tags "GET pokemons"
        consumes "application/json"
        parameter name: :limit, in: :query, type: :integer
        parameter name: :offset, in: :query, type: :integer
        response '200', 'returns paginated pokemons' do
          examples 'application/json' => {
            count: 1118,
            offset: 0,
            previous_url: nil,
            next_url: "#{ENV['HOSTNAME']}/api/v1/pokemons?limit=20&offset=20",
            pokemons: [
              {
                id: 1,
                name: "bulbasaur",
                types: [ { name: 'grass' }, { name: 'poison' } ]
              },
            ]
          }
          run_test! do
            result = {
              count: Pokemon.count,
              offset: offset.to_i,
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
            data = JSON.parse(response.body)
            expect(data.deep_symbolize_keys).to eq(result)
          end

          context 'when limit is 1' do
            let(:limit) { 1 }
            let!(:pokemon_2) { FactoryBot.create(:pokemon, :with_type) }

            run_test! do
              result = {
                count: Pokemon.count,
                offset: offset.to_i,
                previous_url: nil,
                next_url: api_v1_pokemons_url(limit: 1, offset: 1),
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
              data = JSON.parse(response.body)
              expect(data.deep_symbolize_keys).to eq(result)
            end
          end

          context 'when it is last page' do
            let(:limit) { 1 }
            let(:offset) { 1 }
            let!(:pokemon_2) { FactoryBot.create(:pokemon, :with_type) }

            run_test! do
              result = {
                count: Pokemon.count,
                offset: offset,
                previous_url: api_v1_pokemons_url(limit: 1, offset: 0),
                next_url: nil,
                pokemons: [
                  {
                    id: pokemon_2.id,
                    name: pokemon_2.name,
                    types: pokemon_2.types.map do |type|
                      { name: type.name }
                    end
                  },
                ]
              }
              data = JSON.parse(response.body)
              expect(data.deep_symbolize_keys).to eq(result)
            end
          end
        end
      end
    end
  end

  describe "#show" do
    let!(:pokemon) { FactoryBot.create(:pokemon, :with_type) }
    let(:name) { CGI.escape(pokemon.name) }

    path '/api/v1/pokemons/{name}' do
      get 'pokemon' do
        tags "GET pokemon"
        consumes "application/json"
        parameter name: :name, in: :path, type: :string
        response '200', 'returns pokemon info' do
          examples 'application/json' => {
            id: 1,
            name: "bulbasaur",
            base_experience: 64,
            height: 7,
            weight: 69,
            types: [ { name: 'grass' }, { name: 'poison' } ]
          }
          run_test! do
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
            data = JSON.parse(response.body)
            expect(data.deep_symbolize_keys).to eq(result)
          end

          context 'when name is capitalized' do
            let(:name) { CGI.escape(pokemon.name.capitalize) }

            run_test! do
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
              data = JSON.parse(response.body)
              expect(data.deep_symbolize_keys).to eq(result)
            end
          end
        end

        response '404', 'not found' do
          let(:name) { "wrong_name" }

          examples 'application/json' => {
          }
          run_test! do
            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)).to eq({})
          end
        end
      end
    end
  end
end
