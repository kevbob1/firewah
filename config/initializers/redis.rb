$REDIS_ = Redis.new

$REDIS = Redis::Namespace.new(:fw, :redis => $REDIS_ )
