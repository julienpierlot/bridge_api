class Pokemon < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :base_experience, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :height, :weight, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  has_many :pokemon_types, inverse_of: :pokemon
  has_many :types, through: :pokemon_types

  accepts_nested_attributes_for :types

  class << self

    def fetch_pokemons!
      PokemonsFetcher.new.call
    end

    def find_or_create_from_api!(data)
      parsed_data = JSON.parse(data).deep_symbolize_keys
      pokemon = Pokemon.find_or_initialize_by(
        name: parsed_data[:name],
      )
      pokemon.assign_attributes(
        base_experience: parsed_data[:base_experience].to_i,
        height: parsed_data[:height].to_i,
        weight: parsed_data[:weight].to_i,
      )
      pokemon.save
    end
  end
end
