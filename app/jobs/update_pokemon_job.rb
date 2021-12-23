# frozen_string_literal: true

class UpdatePokemonJob < ApplicationJob
  queue_as :default

  def perform
    Pokemon.fetch!
  end
end
