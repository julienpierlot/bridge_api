# frozen_string_literal: true

class Type < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :pokemon_types, inverse_of: :type, dependent: :destroy
  has_many :pokemons, through: :pokemon_types

  class << self
    def find_or_initialize_from_names(names)
      Array.wrap(names).map do |name|
        find_or_initialize_by(name: name)
      end
    end
  end
end
