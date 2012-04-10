require 'Tree'

# Expression - Represents a mathematical expression.
#
# Operating Systems
# Spring 2012
#
# @author Jico Baligod
# @version 1.22.2012
class Expression
  attr_reader :orig, :prefix, :infix, :postfix, :tree
  
  # Creates a new Expression from an infix expressions string.
  # Builds a binary tree upon initialization.
  # @param [String] exp The expression in infix notation.
  def initialize(exp)
    @orig, @tree = exp, create_tree(exp)
    @prefix, @infix, @postfix = @tree.preorder_traverse, @tree.inorder_traverse, @tree.postorder_traverse
  end
  
  # Evaluates the expression. Uses the postfix representation
  # and integer arithmetic.
  # @return [Integer] The value of the evaluated expression.
  def evaluate()        
    # operand stack
    opStack = []
    
    # iterate over the tokens
    @postfix.split("").each do |c|
      # check if an operator
      if %w[+ - * / ^].include? c
        # pop the stack for the two operands where
        # a [operator] b
        b, a = opStack.pop, opStack.pop
        
        # evaluate the string as an arithmetic expression
        # replace all '^' characters with '**' operator
        opStack.push(eval("(#{a})#{c}(#{b})".gsub(/\^/,'**')))
      else
        # push any operands onto stack
        opStack.push(c)
      end
    end
    
    # Last item in stack should be the final answer!
    opStack.pop
  end
  
  # Converts an infix expression to a binary expression tree.
  # @param [String] exp The infix expression.
  # @return [Tree] The resulting binary tree.
  def create_tree(exp)
  	operatorStack, nodeStack = [], []
    
    # define function to create new tree segment
    subtree = Proc.new {
      # pop operands where
      # a [operator] b
      b, a = nodeStack.pop, nodeStack.pop
			nodeStack.push(Tree::Node.new(operatorStack.pop, a, b))
		}
    
  	exp.split("").each do |c|
  		# Skip whitespace characters
  		if c === "\s"
  			next
  		elsif c === ')'
  			until operatorStack.last === '(' do
  				subtree.call
  			end
  			# remove the remaining open parenthesis
  			operatorStack.pop
  		elsif %w|+ - * / ^ (|.include? c
  			if operatorStack.empty? || c === '('
  				operatorStack.push(c)
  			else
  				while precedence_of(operatorStack.last) >= precedence_of(c)
  					subtree.call
  				end
  				operatorStack.push(c)
  			end
  		else
  			nodeStack.push(Tree::Node.new(c))
  		end
  	end

  	until operatorStack.empty? do
  		subtree.call
  	end
    
    # top element of the stack is the root element
  	Tree.new(nodeStack.pop)
  end
  
  # Evaluates the precedence of an operator.
  # @param [Char] ch The character code of the operator.
  # @return [Integer] The precedence value of the operator.
  def precedence_of(ch)
  	case ch
  		when '^'
         	10
  		when '*', '/'
         	5
  		when '+', '-'
         	1
  		else
         	0
  	end
  end
  
end
