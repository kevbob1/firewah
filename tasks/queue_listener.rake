
  
  desc "start queue listener for queue #1"
  task :queue_listener1 => :environment do
    # Create a queue that will listen for a new element for 10 seconds
    Padrino.logger.info "starting queue listener"

    $QUEUE1.process do |message_json|
      message = Oj::load(message_json)

      Padrino.logger.info "queue1: start #{message.message_type}" 

      case message.message_type
      when :refresh

        fw = Fw.new('padlock.pd.o', 'firewall name LAN_IN')
        rules = fw.get_rules
  
        rules.each do |rule| 
          $REDIS.hset("rules", rule.position, Oj::dump(rule))
        end

      when :update_rule
        rule = message.body
        fw = Fw.new('padlock.pd.o', 'firewall name LAN_IN')
        fw.update_rule(rule)

        $REDIS.hset("rules", rule.position, Oj::dump(rule))

      end
      Padrino.logger.info "queue1: finished #{message.message_type}"
      true
    end

  end
