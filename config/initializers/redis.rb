$REDIS_ = Redis.new

$REDIS = Redis::Namespace.new(:fw, :redis => $REDIS_ )

$QUEUE1 = Redis::Queue.new('queue1', 'bp__queue1', redis: $REDIS)
$QUEUE2 = Redis::Queue.new('queue2', 'bp__queue2', redis: $REDIS)