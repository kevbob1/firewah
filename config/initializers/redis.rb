$REDIS_ = Redis.new(host: ENV['REDIS_HOST'] )

$REDIS = Redis::Namespace.new(:fw, :redis => $REDIS_ )

$QUEUE1 = Redis::Queue.new('queue1', 'bp__queue1', redis: $REDIS)