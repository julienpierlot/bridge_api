# Bridge API
This app exposes API endpoints allowing you to read data from multiple sources.
Currently, you will only have Pokemon data, but if you want other sources, please reach out to the admin of this app.
The API documentation is available at https://bridge-api-jp.herokuapp.com/api-docs

## Ruby version
`3.0.0`

## Getting started
### Boot
To start the project, run the following commands in your terminal:
`
bundle install
bin/rails db:setup
`
### Env variables
Create a `.env` at the root of the repo and add variables from `sample.env` file.

### Start server
Then start the server with the command:
`bin/rails s`

## Tests
To run the tests, run the following command:
`bundle exec rspec`

## Update the API documentation
The gem `rswag` is used to manage api docs throught requests specs. To update the doc, run the following command:
`rake rswag:specs:swaggerize`

## Add a new source
If you want to add a new source (eg `marvel_hero`), here are the prerequisites:
 - Add `marvel_hero` at the bottom of `config/sources.yml` file.
 - Create a `MarvelHero` class and make sure it responds to `fetch!`
 - Create a `UpdateMarvelHeroJob` and call `UpdateMarvelHero.fetch!`

## Update sources
In order to update sources, please run the following:
`rake sources:update_all`

## Deployment
This app is hosted on Heroku. A CI/CD has been impemented on this project, which means that if all specs are green when pushing to `main`, deploy will be automatically triggered.

## Contribution
If you want to make a contribution, you will have to make a PR. Please keep in mind that all new feature must be 100% tested, and that no untested code will be merged into `main`.
