#!/usr/bin/env ruby

require 'net/ssh/telnet'



s = Net::SSH::Telnet.new(
        "Host" => "padlock.pd.o",
        "Username" => "admin",
        "Password" => "fl0tilla",
        "Prompt" => %r{^admin@padlock},
        "Terminator" => "\r"
)

commands = [
    'hostname',
    'configure',
    'show firewall broadcast-ping',
    'exit'

]

commands.each do |cmd_string|

    puts s.cmd(cmd_string)

end



s.close