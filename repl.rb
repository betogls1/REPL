#!/usr/bin/env ruby

variables = {}
while true do
  print "REPL >> "
  input = gets.chomp
  case input

  when /\s*[a-zA-Z]\w*\s*=/ # ------------------ variable declaration
	    input.sub!(/(puts|print)\s*/,"")
	    input = input.gsub!(/"/,"\\\"") if input =~ /"/
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
	    input.insert(0,vars)
	    puts `ruby -e "#{vars};puts #{input_arr[1]}"`

  when "quit", "exit" # ------------------------ exit
	    puts "good bye!"
	    abort
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

  when /rm/ # ------------------------------ remove Dir
	    input=input.split(" ")
	    input.shift
	    input.each do |dir|
	      Dir.delete(dir)
	      puts "removed directory #{dir}"
	    end
  else      # ------------------------------- any other operation
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
