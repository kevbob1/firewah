# frozen_string_literal: true

if Padrino.env != :test
  $REDIS_ = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

  $REDIS = Redis::Namespace.new(:fw, redis: $REDIS_)

  $QUEUE1 = Redis::Queue.new('queue1', 'bp__queue1', redis: $REDIS)

  $REDIS_PUBSUB_R = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

  $REDIS_PUBSUB_READ = Redis::Namespace.new(:fw, redis: $REDIS_PUBSUB_R)
end
