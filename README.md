# Bridge API
This app exposes API endpoints allowing you to read data from multiple sources.
Currently, you will only have Pokemon data, but if you want other sources, please reach out to the admin of this app.
The API documentation is available at /api-docs
## Ruby version
`3.0`

## Getting started
To start the project, run the following commands in your terminal:
`
bundle install
bin/rails db:setup
`
Make sure specs are green if you want to update the code base:
`bundle exec rspec`

## Tests
To run the tests, run the following command:
`bundle exec rspec`

## Update the API documentation
The gem `rswag` is used to manage api docs throught requests specs. To update the doc, run the following command:
`rake rswag:specs:swaggerize`

## Add a new source
If you want to add a new source, you need to do the following:
 - Add new source in the `config/sources.yml` file.
 - Create a class for this source, and make sure it responds to `fetch!`

## Update sources
In order to update sources, please run the following:
`rake sources:update_all`

## Deployment
This app is hosted on Heroky. A CI/CD has been impemented on this project, which means that if all specs are green when pushing to `main`, deploy will be automatically triggered.

## Contribution
If you want to make a contribution, you will have to make a PR. Please keep in mind that all new feature must be 100% tested, and that no untested code will be merged into `main`.
