#!/usr/bin/env ruby
require 'tco'


module Options
	@variables = {}


	def self.color(output)
	  puts output.fg("#02a552")
	end

	def self.exit
	  color("good bye!")
	  abort
	end

	def self.define_var(input)
	    input.sub!(/(puts|print)\s*/,"")
            input.gsub!(/"/,"\\\"") if input =~ /"/
            input_arr=input.split('=')
            vars_arr = input_arr[0].split(%r{[,=]})
            vars_arr.delete(" ")
            vars = ""
            vars_arr.each { |var| vars = vars_arr[0] == var ? vars << var.delete(" ") : vars << "," << var.delete(" ") }
            values_arr = input_arr[1].split(%r{[()-+/*]})
            values_arr.delete(" ")
            @variables[vars] = input_arr[1]
            vars=""
            @variables.each {|x,y| vars << "#{x} = #{y};"}
            print ">> "
	    color(`ruby -e "#{vars}puts #{input_arr[1]}"`)
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
	    print ">> "
            color(`ruby -e "#{vars}puts #{input}"`)
	end

	def self.help
                puts "Usage: ".fg("#02a552")
                puts " "
                puts "    - clear                         Clear Screen".fg("#02a552")
                puts "    - pwd                           current directory".fg("#02a552")
                puts "    - ls                            list files".fg("#02a552")
                puts "    - cd    <dir_name>              change directory".fg("#02a552")
                puts "    - mkdir <dir_name>              create directory".fg("#02a552")
                puts "    - rm    <dir_name>              remove directory".fg("#02a552")
                puts "    - touch <file_name> <option (w - by default)>    create file".fg("#02a552")
                puts "    - help  <cmd>                   print help page".fg("#02a552")
	end

	def self.ls
	    files=Dir.entries(Dir.pwd)
            files.each {|file| color("  "+file)}
	end

	def self.cd(input)
	    input=input.split(" ")
            Dir.chdir(input[-1])
            color("#{Dir.pwd}")
	end

	def self.mkdir(input)
	    input=input.split(" ")
            input.shift
            input.each do |dir|
              Dir.mkdir(dir)
              color("directory #{dir} created")
            end
	end

	def self.touch(input)
	    input=input.split(" ")
	    File.write(input[1],"w")
            color("file #{input[1]} created")
	end

	def self.rm(input)
	    input=input.split(" ")
            input.shift
            input.each do |element|
		File.directory?(element) ?  Dir.delete(element) : File.delete(element)
              color("#{element} removed")
            end
	end

end
