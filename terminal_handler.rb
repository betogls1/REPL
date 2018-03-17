#!/usr/bin/env ruby
require 'io/console'
require 'tco'


class Terminal_handler
	def initialize
	  @line = 0
	  @arrow_keys = []
	  @cmds = []
	end

	def clear_screen
	  $stdout.write "\e[2J"
	  $stdout.write "\e[1;1H"	
	end

	def clear_line
	  $stdout.write "\e[200L"
          $stdout.write "\e[u"
	end

	def up_key(input)
	  clear_line
          unless  @cmds.nil?
            @line += 1 unless @line == @cmds.length
            input = @cmds[@cmds.length - @line] 
	    color(input) 
            @col = input.length
          end
	  return input
	end


	def down_key(input)
          @col = input.length if input == ""
	  clear_line
          unless @cmds.nil?
            @line -= 1 unless @line == 0
            last_input = @line != 0 ? @cmds[@cmds.length - @line] : @last_input
#            $stdout.write input
	    color(last_input)
            @col = last_input.length
          end
	  return last_input
	end

	def left_key
	  $stdout.write "\e[1D"
          @col -= 1 unless @col == 0
	end

	def right_key(input)
	  if @col < input.length
	    $stdout.write "\e[1C" 
            @col += 1 
	  end
	end

	def return_key(input)
	  @cmds << input if input != ""
	  return input
	end

	def home_key
	  $stdout.write "\e[u"
          @col = 0
	end

	def end_key(input)
	  $stdout.write "\e[u"
          $stdout.write "\e[#{input.length}C"
          @col = input.length
	  return input
	end

	def backspace_key(input)
          if @col > 0 
	    @col -= 1
            input[@col] = ''
	    clear_line
	    color(input)
            $stdout.write "\e[u"
            $stdout.write "\e[#{@col}C"
	  else
            $stdout.write "\e[u"
	  end
	  return input
	end

	def color(input)
	  input.each_char do |key_pressed|
	    if key_pressed == "\"" && @color_flag == false
              $stdout.write key_pressed.fg("#f37f5a")
              @color_flag = true
            elsif key_pressed == "\"" && @color_flag == true
              $stdout.write key_pressed.fg("#f37f5a")
              @color_flag = false
            elsif @color_flag == true
              $stdout.write key_pressed.fg("#f37f5a")
            else 
              $stdout.write key_pressed.fg("#00aaea")
            end
	  end
	end

	def command(input,key_pressed)
	  input.insert(@col,key_pressed)
          @col += 1
	    if key_pressed == "\"" && @color_flag == false
              $stdout.write key_pressed.fg("#f37f5a")
              @color_flag = true
            elsif key_pressed == "\"" && @color_flag == true
              $stdout.write key_pressed.fg("#f37f5a")
              @color_flag = false
            elsif @color_flag == true
              $stdout.write key_pressed.fg("#f37f5a")
            else 
              $stdout.write key_pressed.fg("#00aaea")
	    end
          if @arrow_keys[-1] == "\e[D" || @arrow_keys[-1] == "\e[C"
            $stdout.write "\e[u"
            $stdout.write "\e[#{@col}C"
          end
	  return input
	end

	def get_input
	  $stdout.write "\e[s"
	  input = ""
	  @last_input = ""
	  @color_flag = false
	  @col = 0
	  while true do
	    STDIN.raw!
	    key_pressed = STDIN.getc
	    if key_pressed == "\e"
	      key_pressed << STDIN.read_nonblock(2) rescue nil ##investigate this 
	      @arrow_keys << key_pressed
	    end
	    STDIN.cooked!
	    case key_pressed
	      when "\e[A","\eOA" ## up key
		input = up_key(input)
	      when "\e[B", "\eOB" ## down key
		input = down_key(input)
	      when "\e[D", "\eOD" ## left key
		left_key
	      when "\e[C", "\eOC" ## right key
		right_key(input)
	      when /\r/   ## RETURN - ENTER
		input = return_key(input)
		break
	      when "\eOH" ## HOME
		home_key
	      when "\eOF" ## END
		input = end_key(input)
	      when /\177/ ## BACKSPACE
		input = backspace_key(input)
	      when /^\e(O\w|\[\d)$/ ## special keys
	      else
		input = command(input,key_pressed)
	        @last_input = input
	    end
	  end
	  return input	
	end

end
