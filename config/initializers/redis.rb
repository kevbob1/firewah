# frozen_string_literal: true

if Padrino.env != :test
  $REDIS_NORMAL = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

  $REDIS = Redis::Namespace.new(:fw, redis: $REDIS_)

  $QUEUE1 = Redis::Queue.new('queue1', 'bp__queue1', redis: $REDIS)

  $REDIS_PUBSUB_ = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

  $REDIS_PUBSUB = Redis::Namespace.new(:fw, redis: $REDIS_PUBSUB_)

end
