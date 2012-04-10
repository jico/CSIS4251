# RExpression
A simple Ruby arithmetic expression to binary tree converter and evaluator.
Supports Ruby 1.8.7.

## Usage

Include the _Expression_ class.
  
    require 'Expression'

Create a new expression.
  
    exp = Expression.new("2*(3+2)^(5-3)")

_Expression_ takes in an infix arithmetic expression string. Acceptable operators
include the usual; listed in the typical order of precedence (least to greatest):

  *  __+__    Addition
  *  __-__    Subtraction
  *  __*__    Multiplication
  *  __/__    Division
  *  __^__    Exponent
  *  __()__   Open/close parentheses

Only single digit integers are accepted. Division is evaluated using integer division.

## Methods

The original expression input:

    >> exp.orig
    => "2*(3+2)^(5-3)"

Evaluate the expression.

    >> exp.evaluate
    => 50

Spit out the different traversals of the binary expression tree.

    >> exp.infix
    => "2*3+2^5-3"
    >> exp.prefix
    => "*2^+32-53"
    >> exp.postfix
    => "232+53-^*"

Print out a nice indentation tree view of the binary expression tree!

    >> exp.tree.show
    *
      2
      ^
        +
          3
          2
        -
          5
          3

If you've never seen the above tree representation style before, no worries. It's pretty simple to understand once you know what you're looking at.

The printed tree uses indentation to mark the levels of the nodes, with the left child 
listed first. So taking the above tree as an example, we can derive the following:

*   The root node is the multiplication operator "*", since it is the first item listed.
*   The next indentation levels lists the elements "2" and "^", which are the left and right child of the root element "*", respectively.
*   The next indentation level lists the elements "+" and "-", which are the left and right child of the node containing the element "^", respectively.
*   Furthermore, we can see the the node containing "2" has no children :(
*   The final indentation level lists "3" and "2", which are the left and right children of the node containing "+"; as well as "5" and "3", which are the left and right children of the node containing "-".

__Note:__ You can increase the overall indentation or _spread_ of the printed tree: `exp.tree.show(3)`

## Expression REPL

You can use portable Ruby (AllInOneRuby included) to run a [REPL](http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop "Read-Eval-Print Loop") for interactively testing the 
Expression class. Run `ruby erepl.rb`, or, simply run one of the `run` files (i.e. double-click `run_windows`) to 
start EREPL. You should be greeted by a prompt:

    Expression REPL!
    Type 'quit' to exit
    
    Enter the expression:
    >> 

Now just enter your expression to invoke all the methods of the Expression class onto it.

    Enter the expression:
    >> (4+2)^2-3*3   
    Infix   => (4+2)^2-3*3
    Postfix => 42+2^33*-
    Prefix  => -^+422*33
    
    Tree =>
    -
      ^
        +
          4
          2
        2
      *
        3
        3
    
    Evaluation => 27

When you're done having fun, type `quit` to exit the REPL.
