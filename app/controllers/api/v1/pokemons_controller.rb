# frozen_string_literal: true

module Api
  module V1
    class PokemonsController < Api::V1::BaseController
      def index
        @pokemons = Pokemon.includes(:types)
                           .offset(params[:offset])
                           .limit(params[:limit] || Pokemon::PAGING)
        @count = Pokemon.count
        render json: {
          count: @count,
          offset: params[:offset].to_i || 0,
          previous_url: previous_url,
          next_url: next_url,
          pokemons: @pokemons.as_json(only: %i[id name], with_types: true)
        },
               status: :ok
      end

      def show
        @pokemon = Pokemon
                   .where(
                     Pokemon.arel_table[:name].lower.matches(params[:name].downcase)
                   ).first
        return render json: {}, status: :not_found unless @pokemon

        render json: @pokemon.as_json(except: %i[created_at updated_at], with_types: true), status: :ok
      end

      private

      def previous_url
        return @previous_url if defined?(@previous_url)
        return @previous_url = nil if params[:offset].to_i.zero?

        @previous_url = api_v1_pokemons_url(
          offset: [params[:offset].to_i - (params[:limit] || Pokemon::PAGING).to_i, 0].max,
          limit: params[:limit] || Pokemon::PAGING
        )
      end

      def next_url
        return @next_url if defined?(@next_url)
        return @next_url = nil if no_next_url?

        @next_url = api_v1_pokemons_url(
          offset: params[:offset].to_i + (params[:limit] || Pokemon::PAGING).to_i,
          limit: params[:limit] || Pokemon::PAGING
        )
      end

      def no_next_url?
        offset_above_count? || all_displayed? || no_remaining?
      end

      def offset_above_count?
        params[:offset].to_i >= @count
      end

      def all_displayed?
        @pokemons.count == @count
      end

      def no_remaining?
        (@count - params[:offset].to_i) <= (params[:limit] || Pokemon::PAGING).to_i
      end
    end
  end
end
