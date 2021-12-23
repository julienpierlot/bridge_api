namespace :sources do
  desc 'Update all sources'
  task update_all: :environment do
    Rails.application.config_for(:sources)['sources'].each do |source|
      source.classify.constantize.send(:fetch!)
    end
  end
end
