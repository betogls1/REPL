#!/usr/bin/env ruby

require_relative 'terminal_handler'
require './options.rb'
terminal = Terminal_handler.new

while true
  puts "REPL >>"
  input = terminal.get_input
  puts ""
  case input
    when /\s*[a-zA-Z]\w*\s*=/ # ------------------ variable declaration
	Options.define_var(input)
    when "quit", "exit" ##========== exit ==========
	    puts "good bye!"
            abort
    when /help/ ##========== help ==========
	Options.help(input)
    when "pwd" # --------------------------------- pwd
            puts Dir.pwd

    when /^\s*ls\s*$/ # --------------------------------- list files
	Options.ls

    when /cd/ # -------------------------------- change Dir
	Options.cd(input)

    when /mkdir/ # ----------------------------  make Dir 
	Options.mkdir(input)

    when /touch/ # ----------------------------  make Dir 
	Options.touch(input)

    when /rm/ # ------------------------------ remove Dir
	Options.rm(input)

    else
	Options.execute(input)
    end
  
end
