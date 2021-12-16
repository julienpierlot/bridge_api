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

end
