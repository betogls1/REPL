#!/usr/bin/env ruby
require 'io/console'

class Terminal_handler
	def initialize
#	  @input = ""
	  @line = 0
#	  @col = 0#input.length
	  @arrow_keys = []
	  @cmds = []
	  $stdout.write "\e[s"
	  @key_pressed = ""
	end
	
	def up_key(input)
          @col = input.length if input == ""
	  $stdout.write "\e[200L"
          $stdout.write "\e[u"
          unless  @cmds.nil?
            @line += 1 unless @line == @cmds.length
#            index = @cmds.length - @line
            input = @line != 0 ? @cmds[@cmds.length - @line] : ""
            $stdout.write input
            @col = input.length if input == ""
          end
	  return input
	end


	def down_key(input)
          @col = input.length if input == ""
	  $stdout.write "\e[200L"
          $stdout.write "\e[u"
          unless @cmds.nil?
            @line -= 1 unless @line == 0
            input = @line != 0 ? @cmds[@cmds.length - @line] : ""
            $stdout.write input
            @col = input.length if input == ""
          end
	  return input
	end

	def left_key
	  $stdout.write "\e[1D"
          @col -= 1 unless @col == 0
	end

	def right_key
	  $stdout.write "\e[1C"
          @col += 1 unless @col == 0
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
#	  $stdout.write "\e[1D \e[1D"
          @col = input.length if input == ""
          @col -= 1 unless @col == 0
          input[@col] = ''
          $stdout.write "\e[200L"
          $stdout.write "\e[u"
          $stdout.write input
          $stdout.write "\e[u"
          $stdout.write "\e[#{@col}C"
	  return input
	end

	def command(input)
	  input.insert(@col,@key_pressed)
          @col += 1
          $stdout.write "\e[u"
          $stdout.write input
          if @arrow_keys[-1] == "\e[D" || @arrow_keys[-1] == "\e[C"
            $stdout.write "\e[u"
            $stdout.write "\e[#{@col}C"
          end
	  return input
	end

	def get_input
	#  $stdout.write "\e[s"
	  input = ""
	  @col = 0
	  while true do
	    STDIN.raw!
	    @key_pressed = STDIN.getc
	    if @key_pressed == "\e"
	      @key_pressed << STDIN.read_nonblock(2) rescue nil 
	      @arrow_keys << @key_pressed
	    end
	    STDIN.cooked!
	    case @key_pressed
	      when "\e[A" ## up key
		input = up_key(input)
	      when "\e[B" ## down key
		input = down_key(input)
	      when "\e[D" ## left key
		left_key
	      when "\e[C" ## right key
		right_key
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
		input = command(input)
	    end
	  end
	  return input	
	end

end
