#!/usr/bin/env ruby -w
#
# Tests run against Expression class
#
# Operating Systems
# Programming Assignment 1
# Spring 2012
#
# @author Jico Baligod
# @version 1.22.2012
require 'Expression'
require 'test/unit'

class ExpressionTest < Test::Unit::TestCase

	def test_create
		assert Expression.new("1+2")
		assert Expression.new("1-2")
		assert Expression.new("1*2")
		assert Expression.new("1/2")
		assert Expression.new("2^3")
		assert Expression.new("(1+2)")
	end
	
	def test_addition
		eqs = [
		  '1+0',
  		'1+2',
  		'3+2',
  		'1+2+5',
  		'8+2+4+1'
		]
		
		eqs.each do |e|
	    assert_equal eval(e), Expression.new(e).evaluate
    end
	end
	
	def test_subtraction	
		eqs = [
		  '1-0',
		  '5-2',
		  '2-5',
		  '9-1-2',
		  '9-2-1-3'
		]
		
		eqs.each do |e|
	    assert_equal eval(e), Expression.new(e).evaluate
    end
	end

	def test_multiplication
		eqs = [
		  '1*0',
  		'6*4',
  		'4*5',
  		'3*1*5', 
  		'9*2*1*3'
		]
		
		eqs.each do |e|
	    assert_equal eval(e), Expression.new(e).evaluate
    end
	end	
	
	def test_division
	  eqs = [
	    '0/1',
  		'1/2',
  		'4/2',
  		'8/2/2', 
  		'8/2/1/2'
	  ]
		
		eqs.each do |e|
	    assert_equal eval(e), Expression.new(e).evaluate
    end
	end
	
	def test_exponent
	  eqs = [
	    '2^0',
  		'2^1',
  		'3^2',
  		'4^5'
	  ]
		
		eqs.each do |e|
	    assert_equal eval(e.gsub(/\^/,'**')), Expression.new(e).evaluate
    end
	end
	
	def test_parentheses
	  eqs = [
	    '(2+5)',
	    '(3*2)+4',
	    '2^(3+4)',
	    '(3+2)-(1+2)',
	    '2*(8/(2+2))',
	    '2+4-(6*2)/(2+2)'
	  ]
	  
	  eqs.each do |e|
	    assert_equal eval(e.gsub(/\^/,'**')), Expression.new(e).evaluate
    end
	end
	
	def test_monster
	  eqs = [
	    '8+7^(2*3*9-0)/2+(4+5-8)-9*2+3',
	    '6-8+8*3+5^6-9/8+(5-9+3^9)-9+(9^7*(6-7+9*4^(5+6^(7-4)))-9+7)',
	    '(4*2+3^2)+(5^9-2*3/(8-5+1))-(9-8+8-9*9)/(2*3)^2'
	  ]
	  
	  eqs.each do |e|
	    assert_equal eval(e.gsub(/\^/,'**')), Expression.new(e).evaluate
    end
	end
	
end
