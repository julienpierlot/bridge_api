# frozen_string_literal: true

class UpdateSourcesJob < ApplicationJob
  queue_as :default

  def perform
    Rails.application.config_for(:sources)['sources'].each do |source|
      "Update#{source.classify}Job".constantize.send(:perform_now)
    end
  end
end
