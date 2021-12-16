class PokemonFetcher

  def call(options = {})
    response = fetch_data(:pokemon, options)
    fetch_pokemon_from_results(response.results)
    while (url = response.next_url)
      call(options_from_next_url(url))
    end
  end

  private

  def fetch_data(resource = :pokemon, options = {})
    params = {
      resource => options
    }.deep_symbolize_keys
    PokeApi.get(**params)
  end

  def fetch_pokemon_from_results(pokemons)
    pokemons.each do |poke|
      poke_info = fetch_data(:pokemon, poke.name)
      Pokemon.find_or_create_from_api!(poke_info.to_json)
    end
    pokemons
  end

  def options_from_next_url(url)
    options = url.split('?').last
      .scan(/(?<key>[a-z]+)\=(?<value>\d+)/)
      .reduce({}) do |hash, option|
        hash.tap { hash[option[0]] = option[1] }
      end
    options
  end
end
