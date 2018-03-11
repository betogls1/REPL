#!/usr/bin/env ruby

require 'io/console'
def get_input(cmds)
input = ""
line = 0
col = input.length
arrow_keys = []
  $stdout.write "\e[s"
  while true do
    STDIN.raw!
    key_pressed = STDIN.getc
    if key_pressed == "\e" then
  #    input << STDIN.read_nonblock(3) rescue nil
      key_pressed << STDIN.read_nonblock(2) rescue nil
      arrow_keys << key_pressed
    end
    STDIN.cooked!
    case key_pressed
    when "\e[A" ## up arrow
	$stdout.write "\e[200L" 
	$stdout.write "\e[u" 
	line += 1
	$stdout.write cmds[cmds.length - line] unless cmds[cmds.length - line].nil?
	input = cmds[cmds.length - line] unless cmds[cmds.length - line].nil?
	col = input.length
    when "\e[B" ## down arrow
	$stdout.write "\e[200L" 
	$stdout.write "\e[u" 
	line -= 1
	$stdout.write cmds[cmds.length - line] unless cmds[cmds.length - line].nil?
	input = cmds[cmds.length - line] unless cmds[cmds.length - line].nil?
	col = input.length
    when "\e[D" ##left arrow
	$stdout.write "\e[1D"
        $stdout.write "\e[s"
	col -= 1 unless col == 0
    when "\e[C" ## right arrow
	$stdout.write "\e[1C" 
    when /\r/ ##return
	#input << cmds[cmds.length - line] unless cmds[cmds.length - line].nil?
	cmds << input
	break
    when /\177/ ##backspace
	$stdout.write "\e[1D \e[1D"
	input = input[0...-1] 
	col -= 1 unless col == 0
    else
	#$stdout.write "\e[200L"
	input.insert(col,key_pressed)
	col += 1 
      if arrow_keys[-1] == "\e[D" 
	$stdout.write "\e[200L"
	$stdout.write input
	$stdout.write "\e[u"
      else
	$stdout.write "\e[u"
	$stdout.write input
      end
   end
  end
  return input
end
cmds = []

while true
  puts "REPL >>"
  input = get_input(cmds)
  puts ""
  puts input
  #puts ">> " + `ruby -e "puts #{input}"`
  abort if input == "exit"
  
end
