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
#      key_pressed << STDIN.read_nonblock(3) rescue nil
      key_pressed << STDIN.read_nonblock(2) rescue nil
      arrow_keys << key_pressed
    end
    STDIN.cooked!
#	p "arr: #{arrow_keys}"
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
	col -= 1 unless col == 0
    when "\e[C" ## right arrow
	$stdout.write "\e[1C" 
	col += 1 unless col == 0
    when /\r/ ##return
	#input << cmds[cmds.length - line] unless cmds[cmds.length - line].nil?
	cmds << input
	break
    when "\eOH" ## home
	$stdout.write "\e[u"
	col = 0
    when "\eOF" ## End
	$stdout.write "\e[u" 
	$stdout.write "\e[#{input.length}C"
	col = input.length
    when /\177/ ##backspace
	$stdout.write "\e[1D \e[1D"
	col -= 1 unless col == 0
	input[col] = ''
	$stdout.write "\e[200L" 
	$stdout.write "\e[u" 
	$stdout.write input
	$stdout.write "\e[u" 
	$stdout.write "\e[#{col}C" 
    when /^\e(O\w|\[\d)$/
    else
	input.insert(col,key_pressed)
	col += 1 
	$stdout.write "\e[u"
	$stdout.write input
	if arrow_keys[-1] == "\e[D" || arrow_keys[-1] == "\e[C"
	 $stdout.write "\e[u" 
	 $stdout.write "\e[#{col}C" 
        end
   end
  end
  return input
end

variables = {}
cmds = []
while true
  puts "REPL >>"
  input = get_input(cmds)
  puts ""
  case input
    when /\s*[a-zA-Z]\w*\s*=/ # ------------------ variable declaration
            input.sub!(/(puts|print)\s*/,"")
            input.gsub!(/"/,"\\\"") if input =~ /"/
            input_arr=input.split('=')
            vars_arr = input_arr[0].split(%r{[,=]})
            vars_arr.delete(" ")
            vars = ""
            vars_arr.each do |var|
              vars = vars_arr[0] == var ? vars << var.delete(" ") : vars << "," << var.delete(" ")
            end
            values_arr = input_arr[1].split(%r{[()-+/*]})
            values_arr.delete(" ")
            variables[vars] = input_arr[1]
            vars=""
            variables.each {|x,y| vars << "#{x} = #{y};"}
           # input.insert(0,vars)
            puts ">> " + `ruby -e "#{vars}puts #{input_arr[1]}"`
    when "quit", "exit" ##========== exit ==========
	    puts "good bye!"
            abort
    when /help/ ##========== help ==========
 	    input=input.split(" ")
            case input[1]
              when "touch"
                puts "    r  - read only. The file must exist"
                puts "    w  - Create an empty file for writing"
                puts "    a  - Append to a file.The file is created if it does not exist."     
                puts "    r+ - Open a file for update both reading and writing. The file must exist."
                puts "    w+ - Create an empty file for both reading and writing."
                puts "    a+ - Open a file for reading and appending. The file is created if it does not exist."
              else
                puts "Usage: "
                puts " "
                puts "    - pwd                           current directory"
                puts "    - ls                            list files"
                puts "    - cd    <dir_name>              change directory"
                puts "    - mkdir <dir_name>              create directory"
                puts "    - rm    <dir_name>              remove directory"
                puts "    - touch <file_name> <option>    create file"
                puts "    - help  <cmd>                   print help page"
              end
    when "pwd" # --------------------------------- pwd
            puts Dir.pwd

    when /ls/ # --------------------------------- list files
            files=Dir.entries(Dir.pwd)
            files.each {|file| puts "  "+file}

    when /cd/ # -------------------------------- change Dir
            input=input.split(" ")
            Dir.chdir(input[-1])
            puts "#{Dir.pwd}"

    when /mkdir/ # ----------------------------  make Dir 
            input=input.split(" ")
            input.shift
            input.each do |dir|
              Dir.mkdir(dir)
              puts "directory #{dir} created"
            end

    when /touch/ # ----------------------------  make Dir 
            input=input.split(" ")
            input.shift
            File.open(input[0],input[1])
            puts "file #{input[0]} created"

    when /rm/ # ------------------------------ remove Dir
            input=input.split(" ")
            input.shift
            input.each do |dir|
              Dir.delete(dir)
              puts "removed directory #{dir}"
            end

    else
	    input.sub!(/(puts|print)\s*/,"")
            input_arr = input.split(/(\+|-|\/|\*|==|>|>=|<|<=|!=|\(|\)|\[|\]|\#{|})/)
	    input = ""
            input_arr.each do |element|
              element.gsub!(/"/,"\\\"") if element =~ /"/
              input <<  element
            end
            vars=""
            variables.each {|x,y| vars << "#{x} = #{y};"}
#            input.insert(0,vars)
	    puts ">> " + `ruby -e "#{vars}puts #{input}"`
    end
#  puts ">> " + `ruby -e "puts #{input}"`
  
end
