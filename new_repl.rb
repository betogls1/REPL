#!/usr/bin/env ruby

require_relative 'terminal_handler'
require './options.rb'
terminal = Terminal_handler.new

while true
  puts "REPL >>"
  input = terminal.get_input
  puts ""
  case input
    when /\s*[a-zA-Z]\w*\s*=/ ## ========== variable definition ==========
	Options.define_var(input)
    when "quit", "exit"       ## ================= exit ==================
	Options.exit
    when "help"               ## ================= help ==================
	Options.help
    when "pwd"                ## ================= pwd ===================
        puts Dir.pwd

    when /^\s*ls\s*$/         ## ============== list files ===============
	Options.ls

    when /^\s*cd\s(.|\w)+\s*$/## ============== change Dir ===============
	Options.cd(input)

    when /^\s*mkdir\s\w+\s*$/ ## ============== make Dir ================
	Options.mkdir(input)

    when /^\s*touch\s\w+\s*$/ ## ============== create Dir ===============
	Options.touch(input)

    when /^\s*rm\s\w+\s*/     ## ============== remove Dir ===============
	Options.rm(input)

    when "clear"              ## ============= Clear Screen ===============
	terminal.clear_screen

    else                      ## =========== execute command =============
	Options.execute(input)
    end
  
end
