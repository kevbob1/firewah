

if !(Padrino.env == :test)

$REDIS_ = Redis.new(host: ENV['REDIS_HOST'], password: "redis" )

$REDIS = Redis::Namespace.new(:fw, :redis => $REDIS_ )

$QUEUE1 = Redis::Queue.new('queue1', 'bp__queue1', redis: $REDIS)
end