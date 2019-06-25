
  
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

        Padrino::WebSockets::BaseEventManager.broadcast(
          :channel, {"message" => "firewall data refreshed", "severity" => "success", "refresh" => true}
          )


      when :update_rule
        rule = message.body
        fw = Fw.new('padlock.pd.o', 'firewall name LAN_IN')
        fw.update_rule(rule)

        $REDIS.hset("rules", rule.position, Oj::dump(rule))
        Padrino::WebSockets::BaseEventManager.broadcast(
          :channel, {"message" => "firewall rule #{rule.position} updated", "severity" => "success", "refresh" => true}
          )

      end
      Padrino.logger.info "queue1: finished #{message.message_type}"
      true
    end
  end

  desc "copy backup and relace active configuration"
  task :reset_from_backup => :environment do
    rule_hash = $REDIS.hgetall("backup_rules")

    rule_hash.each do |k,v|
      rule = Oj::load(v)
      msg = Message.new(:update_rule, rule)
      $QUEUE1 << Oj::dump(msg)
    end




  end
