#!/usr/bin/env ruby

def repl(input = "")
while true do
  print "REPL >> "
  input = gets.chomp
  case input
  when /^\s*(-)*\s*(\d+|[a-zA-Z]\w*)\s*((\+|-|\/|\*)\s*(\d+|[a-zA-Z]\w*)\s*)+$/
      while input =~ /(\/|\*)/ do ####------- multiplication and division
        input_arr = input.split(%r{[*/]})
        element1 = input_arr[0].split(/(\+|-)/)
        element2 = input_arr[1].split(/(\+|-)/)
	index_opt = input.index(%r{[/*]})
	if input[index_opt] == '/'
          operation = element1[-1].to_i / element2[0].to_i
          input.sub!(element1[-1]+"/"+element2[0],operation.to_s)
	else
          operation = element1[-1].to_i * element2[0].to_i
          input.sub!(element1[-1]+"*"+element2[0],operation.to_s)
	end
      end
      while input =~ /(\+|-)/ do ###--------- addition and subtraction
        input_arr = input.split(%r{[-+]})
	index_opt = input.index(%r{[-+]})
#	puts "arr: " + input_arr.to_s
#	puts "str: " + input
	if input[index_opt] == '-'
          operation = input_arr[0].to_i - input_arr[1].to_i
          input.sub!(input_arr[0]+"-"+input_arr[1],operation.to_s)
	else
          operation = input_arr[0].to_i + input_arr[1].to_i
          input.sub!(input_arr[0]+"+"+input_arr[1],operation.to_s)
	end
	break if input[0] == '-'
      end
      puts input
      repl(input)
  when /==/
    puts 'assign'
  when /(\w+)(\d*)(\s*)=/
    puts 'igual'
  when "quit", "exit"
    abort
  else
    puts "wrong"
  end
end
end

repl()
