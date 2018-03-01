#!/usr/bin/env ruby

def opt_file(input,hash = "")
    out_file = File.new("out.rb", "w")
    out_file.puts("#!/usr/bin/env ruby")
    if hash != ''
      hash.each {|key,value| out_file.puts("#{key} = #{value}")}
    end
    out_file.puts("print #{input}")
    File.chmod(0777,"out.rb")
    out_file.close
    return `ruby out.rb`
end

#def repl(input = "")
variables = {}
while true do
  print "REPL >> "
  input = gets.chomp
  case input
  when /\s*[a-zA-Z]\w*\s*=/
    input_arr=input.split('=')
    vars_arr = input_arr[1].split(%r{[()-+/*]})
    vars_arr.delete("")
    defined = true
    vars_arr.each do |element|
      unless element =~ /^\s*(\d|"(\w|\s)*")\s*$/ || variables.key?(element)
        puts "undefined local variable or method #{element}"
	defined = false
      end
    end
    variables[input_arr[0]] = input_arr[1] if defined == true

  when /print/
    print  opt_file(input,variables)

  when /puts/
    puts  opt_file(input,variables)

  when /p/
    p  opt_file(input,variables)

  when /\+|-|\/|\*|==|>|>=|<|<=|!=|\(|\)|\[|\]|\{|\}/ 
    puts  opt_file(input,variables)
 
  when "quit", "exit"
    `rm -rf out.rb`
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
  end
end
#end

#repl()
