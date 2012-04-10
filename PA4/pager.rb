#!/usr/bin/env ruby
#
# procm - Process manager simulator
#
# Operating Systems
# Programming Assignment 4
#
# @author Jico Baligod
#

require 'optparse'

# Parses the given filename and creates a 2x2 array
# holding the jobs with their arrival time and cpu cycles.
#
# Each line of the file must contain two integers indicating
# arrival time and CPU cycles, respectively.
# 
# File:
# arrival1 cycles1
# arrival2 cycles2
# ...
#
# Example:
# 0 6
# 3 2
# 5 1
#
def parse_file(filename)
  arr = []
  File.open(filename, 'r') do |f|
    f.each_line do |line|
      arr << line.chomp
    end
  end
  arr
end

# Allocate a request depending on the algorithm
# specified or defaulted to.
#
def allocate(request)
  print_frames unless @options[:interactive]
  
  # If LRU, move request to end of @algo_list
  # (indicates recently used)
  if @options[:algorithm] == "LRU"
    @algo_list.delete(request) if @algo_list.include?(request)
    @algo_list.push(request)
  end
  
  # If page isn't found, interrupt 
  unless @frames.has_value?(request)
    @interrupts += 1
    
    # Get first free frame, if any
    free = nil
    @options[:frames].times do |frame|
      free = frame if @frames[frame] == nil
      break if free
    end
    
    if free
      # Update @algo_list and assign page to free frame
      @algo_list.push(request) if @options[:algorithm] == "FIFO"
      @frames[free] = request
      return
    else
      # Otherwise, apply allocation algorithm
      first = @algo_list.shift        
      @algo_list.push(request) if @options[:algorithm] == "FIFO"
      frame = nil
      @frames.each { |k,v| frame = k if v == first}
      @frames[frame] = request
    end    
  end
end

# Print the current page frames content in a single row
#
def print_frames
  if @options[:interactive]
    @options[:frames].times { |i| print "Frame #{i}\t" }
    print "\n"
  end
  @options[:frames].times { |i| print @frames[i] ? "#{@frames[i]}\t" : "*\t" }
  print "\n"
end

# Our @options hash
@options = {
  :algorithm    => 'FIFO',
  :frames       => 2,
  :interactive  => false
}

# Specify the options
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: pager [OPTIONS] [FILE]"
  
  # Set the algorithm.
  opts.on('-a', '--algorithm ALGO', 
          'Set the algorithm [FIFO|LRU]:',
          'FIFO - First In First Out',
          'LRU  - Least Recently Used') do |algo|    
    # Identify the units
    @options[:algorithm] = algo.upcase
  end
  
  # Set the number of page @frames
  opts.on('-n', '--frames NUM', 'Set the number of page frames (2-5)') do |n|
    n = n.to_i
    n = [n, 2].max
    n = [n, 5].min
    @options[:frames] = n
  end
  
  opts.on('-i', '--interactive', 'Set interactive mode') do
    @options[:interactive] = true
  end
  
  # Display the help menu
  opts.on('-h', '--help', 'Display this help screen') do
    puts opts
    exit
  end
end

optparse.parse!

# Create page @frames
@frames = {}
0.upto(@options[:frames] - 1) do |i|
  @frames[i] = nil
end

# Glboal vars we need for our algorithm
@interrupts = 0
@algo_list = []

if @options[:interactive]
  puts "Starting interactive pager with"
  puts "#{@options[:frames]} frames using #{@options[:algorithm]} policy"
  print_frames
  requests = 0
  while true do
    print ">> "
    line = STDIN.gets.chomp
    break if line.match /(quit|q|exit)/i
    allocate(line)
    print_frames
    requests += 1
  end
  failure_rate = @interrupts.to_f / requests
  puts "Failure rate = #{@interrupts}/#{requests} (#{failure_rate * 100}%)"
  STDIN.gets
else
  # Grab the filename argument
  filename = ARGV[0]
  puts "Parsing file '#{filename}' using #{@options[:algorithm]} algorithm and #{@options[:frames]} frames"

  # Create requests queue
  requests = parse_file(filename)
  
  requests.each { |request| allocate(request) }
  
  @options[:frames].times { |i| print @frames[i] ? "#{@frames[i]}\t" : "*\t" }
  print "\n"

  failure_rate = @interrupts.to_f / requests.size
  puts "Failure rate = #{@interrupts}/#{requests.size} (#{failure_rate * 100}%)"
end