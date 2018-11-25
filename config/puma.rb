# config/puma.rb
#workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['PADRINO_MAX_THREADS'] || 5)
#threads threads_count, threads_count
threads 1, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'
