# frozen_string_literal: true

require_relative 'client'

puts('Type in a port number (3336 by default):')
port = gets.chomp.to_i

client = Client.new(port)
loop do
  output = ''
  output = client.capture_output until output != ''
  if output.include?(':')
    print output
    client.provide_input(gets.chomp)
  else
    puts output
  end
end
