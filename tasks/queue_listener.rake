
  
  desc "start queue listener for queue #1"
  task :queue_listener1 => :environment do
    # Create a queue that will listen for a new element for 10 seconds

    $QUEUE1.process do |message|
      Padrino.logger.info "queue1: start rule cache refresh"

      fw = Fw.new('padlock.pd.o', 'firewall name LAN_IN')

      rules = fw.get_rules
  
      rules.each do |rule| 
        $REDIS.hset("rules", rule.position, rule.to_yaml)
      end

      Padrino.logger.info "queue1: finished refreshing cached rules"
    end

  end

  desc "start queue listener for queue #2"
  task :queue_listener2 => :environment do
    # Create a queue that will listen for a new element for 10 seconds
    $QUEUE2.process do |message|



    end

  end
