#!/usr/bin/env ruby

module Options
	  @variables = {}

	def self.define_var(input)
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
            @variables[vars] = input_arr[1]
            vars=""
            @variables.each {|x,y| vars << "#{x} = #{y};"}
            puts ">> " + `ruby -e "#{vars}puts #{input_arr[1]}"`
	end

	def self.execute(input)
	    input.sub!(/(puts|print)\s*/,"")
            input_arr = input.split(/(\+|-|\/|\*|==|>|>=|<|<=|!=|\(|\)|\[|\]|\#{|})/)
            input = ""
            input_arr.each do |element|
              element.gsub!(/"/,"\\\"") if element =~ /"/
              input <<  element
            end
            vars=""
            @variables.each {|x,y| vars << "#{x} = #{y};"}
            puts ">> " + `ruby -e "#{vars}puts #{input}"`
	end

	def self.help(input)
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
	end

	def self.ls
	    files=Dir.entries(Dir.pwd)
            files.each {|file| puts "  "+file}
	end

	def self.cd(input)
	    input=input.split(" ")
            Dir.chdir(input[-1])
            puts "#{Dir.pwd}"
	end

	def self.mkdir(input)
	    input=input.split(" ")
            input.shift
            input.each do |dir|
              Dir.mkdir(dir)
              puts "directory #{dir} created"
            end
	end

	def self.touch(input)
	    input=input.split(" ")
            input.shift
            File.open(input[0],input[1])
            puts "file #{input[0]} created"
	end

	def self.rm(input)
	    input=input.split(" ")
            input.shift
            input.each do |dir|
              Dir.delete(dir)
              puts "removed directory #{dir}"
            end
	end

end
