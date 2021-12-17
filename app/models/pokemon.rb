# frozen_string_literal: true

class Pokemon < ApplicationRecord
  PAGING = 20

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :base_experience, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :height, :weight, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  has_many :pokemon_types, inverse_of: :pokemon, dependent: :destroy
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
      pokemon.types.each(&:mark_for_destruction)
      types_names = parsed_data[:types]&.map { |t| t.dig(:type, :name) }
      pokemon.assign_attributes(
        base_experience: parsed_data[:base_experience].to_i,
        height: parsed_data[:height].to_i,
        weight: parsed_data[:weight].to_i,
        types: Type.find_or_initialize_from_names(types_names),
      )
      pokemon.save
    end
  end

  def as_json(options = nil)
    super(options).tap do |json_hash|
      if options[:with_types]
        json_hash['types'] = types.map do |type|
          { name: type.name }
        end
      end
    end
  rescue StandardError
    super(options)
  end
end
