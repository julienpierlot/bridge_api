Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :pokemons, param: :name, only: %i[index show]
    end
  end
  root to: redirect('/api-docs')
end
