

class Fw

    def initialize(host, base_config)
        @base_config = base_config
@s = Net::SSH::Telnet.new(
        "Host" => host,
        "Username" => "admin",
        "Password" => "fl0tilla",
        "Prompt" => %r{^admin@padlock},
        "Terminator" => "\r"
)
    end


def f()
commands.each do |cmd_string|

    puts s.cmd(cmd_string)

    s.close
end

end



end