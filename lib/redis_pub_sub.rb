class RedisPubSub
  require 'oj'

    def initialize(read_connection, write_connection, topic)
      @read_connection = read_connection
      @write_connection = write_connection
      @topic = topic

      if @read_connection.nil? or @write_connection.nil?
        raise "can not have nil redis connections"
      end
    end

    def start
      puts "starting subscriber thread"
      Thread.new do
        Thread.current.abort_on_exception = true
        @read_connection.subscribe(@topic) do |on|
          on.subscribe do |channel, subscriptions|
            puts "Subscribed to ##{channel} (#{subscriptions} subscriptions) (#{Thread.current})"
          end
    
          on.message do |channel, message|
            puts "#sub message received #{channel}: #{message} (#{@event_manager})"

            container = ::Oj.load(message)
            
            if container["type"] == "broadcast"
              @event_manager.broadcast_local(*container["args"])

            elsif container["type"] == "direct"
              @event_manager.send_message_local(*container["args"])
            else
              puts "#invalid sub message #{channel}: #{message} (#{@event_manager})"
            end
          end
    
          on.unsubscribe do |channel, subscriptions|
            puts "Unsubscribed from ##{channel} (#{subscriptions} subscriptions) (#{Thread.current})"
          end
        end
      end
    end

    # hold on to reference of local event manager
    # use this to forward messages to local websocket connections
    def event_manager=(event_manager)
      @event_manager = event_manager
      start
    end

    # handle broadcast messages
    # note:  alternate implementations should *NOT* send to a pub-sub systems *AND*
    # local event manager.  it causes duplicate message propogation to local websocket
    # connections
    def broadcast(*args)
      @write_connection.publish(@topic, ::Oj.dump({"type" => "broadcast", "args" => args}))
    end

    # note:  alternate implementations should *NOT* send to a pub-sub systems *AND*
    # local event manager.  it causes duplicate message propogation to local websocket
    # connections
    def send_message(channel, user, message)
      @write_connection.publish(@topic, ::Oj.dump({"type" => "direct", "args" => args}))
    end
end