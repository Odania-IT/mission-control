redis_connection = Redis.new(:host => ENV['REDIS_1_PORT_6379_TCP_ADDR'], :port => ENV['REDIS_1_PORT_6379_TCP_PORT'])
$redis = Redis::Namespace.new(:mission_control, :redis => redis_connection)
