require 'rails_helper'

RSpec.describe Type, type: :model do
  describe 'Attributes' do
    it { should have_db_column(:name).with_options(null: false) }
  end

  describe 'Validations' do
    subject { FactoryBot.build(:type) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'Associations' do
    it { should have_many(:pokemon_types) }
    it { should have_many(:pokemons).through(:pokemon_types) }
  end

  describe 'Class Methods' do
    describe '.find_or_initialize_from_names' do
      let(:name) { FactoryBot.attributes_for(:type)[:name] }

      context 'when name matches existing type' do
        let!(:type) { FactoryBot.create(:type, name: name) }

        it 'finds type' do
          expect(described_class.find_or_initialize_from_names([name])).to include(type)
        end
      end
      context 'when name does not match existing type' do
        it 'initializes type' do
          expect(
            described_class.find_or_initialize_from_names([name])[0].new_record?
          ).to eq(true)
        end
      end
    end
  end

end
