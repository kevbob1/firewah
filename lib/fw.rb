# frozen_string_literal: true

class Fw
  class Rule
    attr_accessor :position
    attr_accessor :description
    attr_accessor :enabled
    attr_accessor :start_time
    attr_accessor :stop_time

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

  def get_rules
    s = self.connection
    begin
        s.cmd("configure")
        s.cmd("edit #{@base_config}")
        output = s.cmd("show|tee")
        s.cmd('exit')
        return self.class.parse_fw(output)
    ensure
      s.close
    end
  end

  def update_rule(rule)
    s = self.connection
    begin
        s.cmd("configure")
        s.cmd("edit #{@base_config} rule #{rule.position}")
        s.cmd('exit')
        return self.class.parse_fw(output)
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
