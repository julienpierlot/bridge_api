require 'rails_helper'

RSpec.describe PokemonType, type: :model do
  describe 'Attributes' do
    it { should have_db_column(:pokemon_id) }
    it { should have_db_column(:type_id) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:pokemon) }
    it { should validate_presence_of(:type) }
  end

  describe 'Associations' do
    it { should belong_to(:pokemon) }
    it { should belong_to(:type) }
  end
end
