class Type < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :pokemon_types, inverse_of: :type
  has_many :pokemons, through: :pokemon_types

end
