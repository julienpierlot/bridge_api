require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  describe 'Attributes' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:base_experience).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:height).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:weight).of_type(:integer).with_options(null: false) }
  end

  describe 'Validations' do
    subject { FactoryBot.build(:pokemon) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_numericality_of(:base_experience).only_integer.is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:height).only_integer.is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:weight).only_integer.is_greater_than_or_equal_to(1) }
  end

  describe 'Associations' do
    it { should have_many(:pokemon_types) }
    it { should have_many(:types).through(:pokemon_types) }
  end

  describe 'Class Methods' do
    describe '.find_or_create_from_api!' do
      let(:payload) do
        FactoryBot.attributes_for(:pokemon)
      end

      context 'when pokemon does not exist with same name' do
        it 'creates a new pokemon' do
          expect do
            described_class.find_or_create_from_api!(payload.to_json)
          end.to change { described_class.count }.by(1)
        end
      end

      context 'when attributes have types' do
        let(:payload) do
          FactoryBot.attributes_for(
            :pokemon,
            types: [
              { type: { name: Faker::Types.rb_string } }
            ]
          )
        end

        it 'creates new types as well' do
          expect do
            described_class.find_or_create_from_api!(payload.to_json)
          end.to change { Type.count }.by(1)
        end
      end

      context 'when pokemon exists with same name' do
        let!(:pokemon) { FactoryBot.create(:pokemon, name: payload[:name]) }

        it 'does not create a new pokemon' do
          expect do
            described_class.find_or_create_from_api!(payload.to_json)
          end.to change { described_class.count }.by(0)
        end

        it 'updates pokemon attributes' do
          described_class.find_or_create_from_api!(payload.to_json)
          pokemon.reload
          expect(pokemon.base_experience).to eq(payload[:base_experience])
          expect(pokemon.height).to eq(payload[:height])
          expect(pokemon.weight).to eq(payload[:weight])
        end

        context 'when payload has types' do
          let(:payload) do
            FactoryBot.attributes_for(
              :pokemon,
              types: [
                { type: { name: Faker::Types.rb_string } }
              ]
            )
          end

          context 'when pokemon already has a type' do
            let!(:pokemon) { FactoryBot.create(:pokemon, :with_type, name: payload[:name]) }

            it 'deletes old type and creates a new one' do
              described_class.find_or_create_from_api!(payload.to_json)
              pokemon.reload
              expect(pokemon.types.count).to eq(1)
              expect(pokemon.types.last.name).to eq(payload[:types][0][:type][:name])
            end
          end
        end
      end
    end

    describe '.fetch_pokemons!' do
      it 'calls Pokemon Fetcher service' do
        expect_any_instance_of(PokemonsFetcher).to receive(:call)
        
        described_class.fetch_pokemons!
      end
    end
  end

end
