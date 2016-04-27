#!/usr/bin/env ruby
#
# Useage: ./argparse --whiches argument1 -doer="we" match
# Useage: ./argparse --whiches argument2 -doer="them" unmatch
#
############################################################

command = ARGV.to_s

class Argparser
	def parse(command)
		command_object = {}
		# nitpic: Be clear about what you're splitting on - Here it's `.split(' ')` but I had to read the docs to findout
		command_parts = command.split
		# nitpic: `index` is typically `i`
		command_parts.each_with_index do |part, index|
			# If this is an argument with data (ie: command -h=foo)
			if part.include?('-') && part.include?('=')
				# Ack!  What is a part? What is a sub part? Give them names!
				# I'm thinking its "command_string" -> "arg" -> "arg_part" ? command_parts, parts and sub_parts is confusing
				sub_parts = part.split('=')
				# nitpic:  What is going on with '-"][,' ? Since you use it 3 times, you might define it with a
				# name that helps understand what it is (command_special_chars?)
				# Also, It looks like you could `.delete('-"][,')` on `part`
				command_key = sub_parts[0].delete('-"][,')
				command_value = sub_parts[1].delete('-"][,')
				command_object[command_key]	= command_value
				# So a rewritten version of this block might be:
				# sub_parts = part.delete('-"][,').split('=')
				# command_object[sub_parts[0]] = sub_parts[1]
			# If this is an argument without any data (ie: command -h)
			elsif part.include?('-')
				# seems strange again... Not sure what .delete('-"[,') is supposed to be doing
				command_key = part.delete('-"[,')
				# Incrementing the index? So we skip the next "part"? Why would we skip the next part?
				command_value = command_parts.slice!(index+=1).delete('-"][,')
				# This branch seems generic to the previous one
				command_object[command_key]	= command_value
				# For example, the same code proposed above should still work if there no '='
				# sub_parts = part.delete('-"][,').split('=')
				# command_object[sub_parts[0]] = sub_parts[1]
				# With the exception that I dont really understand the intention of `parts.slice!(index+=1).delete`
			# If this isn't an argument, ie: (command somestr)
			else
				# Then we set it as a key of the command object with a hash as the body? Seems strange?
				command_object[part.delete('-"][,')] = {}
			end
		end
		return command_object
	end
end

class Program
	def initialize(pasable_command_object)
		pasable_command_object.each do |command_name, command_data|
			if Program.method_defined? command_name
				self.method(command_name).call(command_data)
			else
				puts 'invalid command'
			end
		end
	end

	@@arguments = {}
	def whiches(key_argument)
		puts 'whiches called with ' + key_argument
		@@key_argument = key_argument
		@@arguments[key_argument] = ''
	end

	def doer(value_argument)
		puts 'doer called with ' + value_argument
		@@arguments[@@key_argument] = value_argument	
	end

	def match(argument_object)
		puts 'match was run expecting argument1 => we'
		puts 'got ', @@arguments
	end

	def unmatch(argument_object)
		puts 'unmatch was run expecting argument2 => them'
		puts 'got ', @@arguments
	end
end 

parser = Argparser.new

pasable_command_object = parser.parse(command)

puts pasable_command_object

run_program = Program.new(pasable_command_object)
