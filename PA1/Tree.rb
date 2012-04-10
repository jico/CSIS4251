# Tree - Represents a binary tree.
#
# Operating Systems
# Spring 2012
# Programming Assignment 1
#
# @author Jico Baligod
# @version 1.22.2012
class Tree
  attr_reader :root
  
  # Creates a new Tree instance.
  # @param [Node] root The root of the tree.
  def initialize(root=nil)
    @root = root
  end
  
  # Recursively traverse the tree in preorder.
  # @param [Node] root The root of the (sub)tree to traverse.
  # @return [String] A string representation of the preorder traversal.
  def preorder_traverse(root=@root)
      unless !root
        result = "#{root.data}"
        result << preorder_traverse(root.left) unless !root.left
        result << preorder_traverse(root.right) unless !root.right
        result
      end
  end
  
  # Recursively traverse the tree in inorder.
  # @param [Node] root The root of the (sub)tree to traverse.
  # @return [String] A string representation of the inorder traversal.
  def inorder_traverse(root=@root)
    unless !root
      result = root.left ? "#{inorder_traverse(root.left)}" : ""
      result << root.data
      result << inorder_traverse(root.right) unless !root.right
      result
    end
  end
  
  # Recursively traverse the tree in postorder.
  # @param [Node] root The root of the (sub)tree to traverse.
  # @return [String] A string representation of the postorder traversal.
  def postorder_traverse(root=@root)
    unless !root
      result = root.left ? "#{postorder_traverse(root.left)}" : ""
      result << postorder_traverse(root.right) unless !root.right
      result << root.data
      result
    end
  end
  
  # Recursively preorder traverses the tree and prints
  # the elements and structure using indentation-based heirarchy.
  # @param [Integer] spread How spaced out the tree will display.
  # @param [Node] root The root of the tree.
  # @param [Integer] indent Indent level.
  def show(spread=2, root=@root, indent=0)
    unless !root
      puts "#{" "*indent*spread}#{root.data}"
      show(spread, root.left, indent + 1)
      show(spread, root.right, indent + 1)
    end
  end
  
  # Node - Represents a binary tree node.
  class Node
  	attr_accessor :data, :left, :right

    # @param data The data held by the Node.
    # @param [Node] left The left child of the Node.
    # @param [Node] right The right child of the Node.
  	def initialize(data=nil, left=nil, right=nil)
  		@data, @left, @right = data, left, right
  	end
  end
  
end