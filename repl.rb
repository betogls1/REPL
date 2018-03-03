#!/usr/bin/env ruby

variables = {}
while true do
  print "REPL >> "
  input = gets.chomp
  case input

  when /\s*[a-zA-Z]\w*\s*=/ # -- assign
	    input = input.gsub!(/"/,"\\\"") if input =~ /"/
	    input_arr=input.split('=')
	    vars_arr = input_arr[1].split(%r{[()-+/*]})
	    vars_arr.delete("")
	    defined = true
	    vars_arr.each do |var|
	      unless var =~ /^\s*(\d+|\\"(\w|\s)*\\")\s*$/ || variables.key?(var)
	        puts "undefined local variable or method #{var}"
		defined = false
	      end
	    end
	    variables[input_arr[0].delete(" ")] = input_arr[1] if defined == true

  when "quit", "exit"
	    puts "good bye!"
	    abort
  when "pwd"
	    puts Dir.pwd

  when /ls/
	    files=Dir.entries(Dir.pwd)
	    files.each {|file| puts "  "+file}
	
  when /cd/ 
	    input=input.split(" ")
	    Dir.chdir(input[-1])
	    puts "#{Dir.pwd}"

  when /mkdir/ 
	    input=input.split(" ")
	    input.shift
	    input.each do |dir|
	      Dir.mkdir(dir)
	      puts "directory #{dir} created"
            end

  when /rm/
	    input=input.split(" ")
	    input.shift
	    input.each do |dir|
	      Dir.delete(dir)
	      puts "removed directory #{dir}"
	    end
  else
	input.sub!(/(puts|print)\s*/,"")
	input_arr = input.split(/(\+|-|\/|\*|==|>|>=|<|<=|!=|\(|\)|\[|\]|\#{|})/)
	input = "puts "
	input_arr.each do |element|
	  element.gsub!(/"/,"\\\"") if element =~ /"/
	  input <<  element
	end
	vars=""
	variables.each {|x,y| vars << "#{x} = #{y};"}
	input.insert(0,vars)
	puts `ruby -e "#{input}"`

  end 
end
