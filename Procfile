web: bundle exec puma -C config/puma.rb
worker: bundle exec rake resque:work QUEUE=*
clock:  bundle exec rake resque:scheduler