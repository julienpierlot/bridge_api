# frozen_string_literal: true

namespace :sources do
  desc 'Update all sources'
  task update_all: :environment do
    UpdateSourcesJob.perform_later
  end
end
