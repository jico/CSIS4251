#!/usr/bin/env ruby
#
# memv.rb - Launch a virtual memory management environment.
#
# @author Jico Baligod
# @version February 27, 2012
#
require 'optparse'
require './MemManager.rb'
require './MemvUtils.rb'

# Our options hash
options = {}

# Parse passed options
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: memv [options]"
  
  # Set the memory size.
  # Can specify units (K|M|G)
  # Defaults to K (kilobytes)
  options[:memsize] = 0
  opts.on('-m', '--memory-size SIZE', 'Set memory size.') do |size|    
    # Identify the units
    options[:memsize] = MemvUtils.parse_size(size)
  end
  
  # Set the partitioning scheme
  # Defaults to fixed
  options[:dynamic] = true
  opts.on('-p', '--partition SIZE', 'Set fixed partitions of size SIZE', 'Defaults to dynamic partitions if unspecified') do |size|
    options[:dynamic], options[:partSize] = false, MemvUtils.parse_size(size)
  end
  
  # Set the allocation algorithm
  options[:algorithm] = "first"
  opts.on('-a', '--algorithm ALGORITHM', 'Set the allocation algorithm (first|best|next|worst)', 'Default: "first"') do |algorithm|
    if ['first','best','next','worst'].include?(algorithm)
      options[:algorithm] = algorithm
    else
      puts "Invalid argument: #{algorithm}. Must be one of 'first', 'best', 'next', or 'worst'."
      exit
    end
  end
  
  # Display the help menu
  opts.on('-h', '--help', 'Display this help screen') do
    puts opts
    exit
  end
end

optparse.parse!

puts "Memory size: #{options[:memsize]} bytes"
puts "Allocation scheme: #{options[:dynamic] ? 'dynamic' : 'fixed'}"
puts "Using #{options[:algorithm]}-fit allocation algorithm"

# Create virtual manager
manager = MemManager.new( options[:memsize], 
                          :dynamic    => options[:dynamic], 
                          :partSize   => options[:partSize],
                          :algorithm  => options[:algorithm])

# Main interactive console loop
puts "Starting interactive console"
puts "('q|quit' to exit)"
puts "=" * 40
while(true) do
  print ">> "
  line = gets.chomp
  break if line =~ /q/i
  # Parse the command
  args = line.split(" ").to_a
  case args[0]
  # Allocate mem for a job
  # Usage: alloc SIZE(k|m|g)
  when 'alloc', 'a'
    size = MemvUtils.parse_size(args[1])
    puts manager.allocate(size, options[:algorithm])
  # Deallocate a job
  # Usage: dealloc JOBNUM
  when 'dealloc', 'd'
    manager.deallocate(args[1].to_i)
    manager.show_jobs()
  # Show active jobs
  when 'jobs', 'j'
    manager.show_jobs()
  # Show partition table
  when 'partitions', 'p'
    manager.show_partition_table
  when 'fragmentation', 'f'
    puts manager.calculate_fragmentation
  else
    MemvUtils.show_help()
  end
end