#
# Expression REPL
# This script provides an interactive console for
# running the Expression class.
require "Expression.rb"

puts "Expression REPL!"
puts "Type 'quit' to exit\n\n"

s, q = nil, false
while true  do
	puts "Enter the expression:"
	print ">> "
	s = gets.chomp
  break if s == "quit"

  begin
    exp = Expression.new(s) 
	
  	puts "\nInfix   => #{exp.infix}"
  	puts "Postfix => #{exp.postfix}"
  	puts "Prefix  => #{exp.prefix}"
  	puts "\nTree =>"
  	exp.tree.show
  	puts "\nEvaluation => #{exp.evaluate}\n\n"
  rescue
    puts "Invalid expression, unable to evaluate."
    puts "Single digit integers only."
    puts "Acceptable operators: +,-,*,/,(,)\n\n"
    next
  end
end
