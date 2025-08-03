web: bundle exec puma -C config/puma.rb
release: bundle exec rails db:migrate && bundle exec rails db:migrate:cache && bundle exec rails db:migrate:queue && bundle exec rails db:migrate:cable
