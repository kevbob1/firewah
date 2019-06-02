# frozen_string_literal: true

class Fw
  class Rule
    attr_accessor :position
    attr_accessor :description
    attr_accessor :enabled
    attr_accessor :start_time
    attr_accessor :stop_time

    def logger
      Padrino.logger
    end

    def initialize
      @enabled = true
    end

  end

  def initialize(host, base_config)
    @base_config = base_config
    @host = host
  end

  def connection
    s = Net::SSH::Telnet.new(
        "Host" => @host,
       "Username" => "admin",
       "Password" => "fl0tilla",
       "Prompt" => %r{^admin@padlock},
       "Terminator" => "\r")
    return s
  end

  def log_cmd(s, command)
    logger.debug "> #{command}"
    response = s.cmd(command)
    logger.debug "< #{response}"
    return response
  end

  def get_rules
    s = self.connection
    begin
        log_cmd(s,"configure")
        log_cmd(s,"edit #{@base_config}")
        output = log_cmd(s,"show|tee")
        log_cmd(s,'exit')
        v = self.class.parse_fw(output) 
        logger.debug v.inspect
        return v
    ensure
      s.close
    end
  end

  def update_rule(rule)
    s = self.connection
    begin
      log_cmd(s,"configure")
      log_cmd(s, "edit #{@base_config} rule #{rule.position}")
        # description 
        log_cmd(s, "set description \"#{rule.description}\"")
        # enabled
        if rule.enabled
          log_cmd(s, "delete disable")
        else
          log_cmd(s, "set disable")
        end
        
        # start
        log_cmd(s, "set time starttime #{rule.start_time}")
        # stop
        log_cmd(s, "set time stoptime #{rule.stop_time}")

        log_cmd(s, "commit")
        log_cmd(s, "save")
        log_cmd(s, 'exit')
        log_cmd(s, 'exit')
    ensure
      s.close
    end
  end


  def self.parse_fw(input)
    rules = []
    lines = input.lines.map(&:chomp)

    r = nil
    lines.each do |line|
      # start rule
      if /rule (\d+) \{/ =~ line
        r = Rule.new
        r.position = Regexp.last_match(1).to_i
        rules << r

      elsif !r.nil?
        # description
        if /description "{0,1}([^"]+)"{0,1}$/ =~ line
            r.description = Regexp.last_match(1)
        end

        # enabled
        if /^\s*disable\s*$/ =~ line
            r.enabled = false
        end

        # start time
        if /starttime (.+)$/ =~ line
            r.start_time = Regexp.last_match(1)
        end

        # stop time
        if /stoptime (.+)$/ =~ line
            r.stop_time = Regexp.last_match(1)
        end
      end
    end
    rules
  end

end
