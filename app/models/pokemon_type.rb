# frozen_string_literal: true

class PokemonType < ApplicationRecord
  validates :type, :pokemon, presence: true

  belongs_to :type
  belongs_to :pokemon
end
