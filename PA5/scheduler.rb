#!/usr/bin/env ruby
#
# scheduler - Process scheduler simulator
#
# Operating Systems
# Programming Assignment 5
#
# @author Jico Baligod
#

# Provides easy rounding for Floats
#
class Float
  def round_to(x)
    (self * 10**x).round.to_f / 10**x
  end
end

# Run through data using First Come First Serve.
# Arrival times are not considered.
#
def schedule_fcfs(data)
  time = data.first[:arrival]
  waiting_sum = turnaround_sum = 0

  data.each do |obj|    
    # Waiting time is current time - arrival time
    waiting_sum += time - obj[:arrival]
    # Turnaround is completion - arrival
    time += obj[:cpu_cycles]
    turnaround_sum += time - obj[:arrival]
  end
  
  avg_waiting = waiting_sum.to_f / data.length
  avg_turnaround = turnaround_sum.to_f / data.length
  { :policy => 'FCFS', 
    :waiting_avg => avg_waiting.round_to(2), 
    :turnaround_avg => avg_turnaround.round_to(2) }
end

# Run through data using Shortest Job Next.
# Arrival times are not considered.
#
def schedule_sjn(data)
  sorted_data = data.sort { |a,b| a[:cpu_cycles] <=> b[:cpu_cycles] }
  result = schedule_fcfs(sorted_data)
  result[:policy] = 'SJN'
  result
end

# Run through data using Shortest Remaining Time
#
def schedule_srt(data)
  time = 0
  done, queue, running = [], [], nil
  
  # Create/reset needed extra data stores for each process
  data.each do |process|
    process[:completed] = nil
    process[:wait] = 0
    process[:remaining] = process[:cpu_cycles]
  end
  
  # Main loop
  while true do
    # Check for processes which arrive at this time
    # If they do, stick them in the queue
    data.each { |process| queue.push process if process[:arrival] == time }
    
    time += 1
    
    # Grab next in queue if nothing is running
    running = queue.pop if running.nil?
    
    unless running.nil?
      # Decrease remaining CPU cycles
      running[:remaining] -= 1
      if running[:remaining] == 0
        # Record completed time if finished
        running[:completed] = time
        done << running
        running = nil
      end
    end
    
    # Check for the SRT in queue and place in running
    # Other processes in queue: bump waiting time
    queue.each do |process|
      process[:wait] += 1
      if running.nil? || process[:remaining] < running[:remaining]
        queue.push running unless running.nil?
        running = process
        queue.delete process
      end
    end
    
    # Break if completed all jobs
    break if done.length == data.length    
  end
  
  # Generate averages
  waiting_sum = turnaround_sum = 0
  done.each do |p|
    waiting_sum += p[:wait]
    turnaround_sum += p[:completed] - p[:arrival]
  end
  
  { :policy => 'SRT', 
    :waiting_avg => (waiting_sum.to_f / done.length).round_to(2), 
    :turnaround_avg => (turnaround_sum.to_f / done.length).round_to(2) }
end

# Run through data using Round Robin
#
def schedule_rr(data)
  time, done, queue, running = 0, [], [], nil
  
  # Reset needed data stores for each process
  data.each do |process|
    process[:completed] = nil
    process[:wait] = 0
    process[:remaining] = process[:cpu_cycles]
  end
  
  while true do
    # Check for processes which arrive at this time
    data.each { |process| queue << process if process[:arrival] == time }
        
    # Increment wait time for jobs in queue queue
    queue.each { |process| process[:wait] += 1 }
    
    # Increment timers
    time += 1
    
    if running.nil? || time % 4 == 0
      deck = queue.pop
      queue.push running unless running.nil?
      running = deck
    end
    
    # Decrease remaining CPU cycles
    running[:cpu_cycles] -= 1 unless running.nil?
    if !running.nil? && running[:cpu_cycles] == 0
      # Record completed time
      running[:completed] = time
      done << running
      running = nil
    end
    
    # Break if completed all jobs
    break if done.length == data.length    
  end
  
  # Generate averages
  waiting_sum = turnaround_sum = 0
  done.each do |p|
    waiting_sum += p[:wait]
    turnaround_sum += p[:completed] - p[:arrival]
  end
  
  { :policy => 'RR', 
    :waiting_avg => (waiting_sum.to_f / done.length).round_to(2), 
    :turnaround_avg => (turnaround_sum.to_f / done.length).round_to(2) }
end

puts "Starting process scheduler simulator."
puts "\nEnter the process data in the following format:"
puts "arrival_time cpu_cycles"
puts "\nParameters must be separated with spaces followed by RETURN."
puts "arrival_time must be in increasing order."
puts "Enter blank or 'end' when finished."

data = []
while true do
  print ">> "
  input = STDIN.gets.split
  break if input[0] == 'end' || input.empty?
  data << { :arrival => input[0].to_i, :cpu_cycles => input[1].to_i }
end

results = []
results << schedule_fcfs(data)
results << schedule_sjn(data)
results << schedule_srt(data)
results << schedule_rr(data)

printf "%-15s %-15s %-15s\n", 'Policy', 'Avg Wait', 'Avg Turnaround'
results.each do |r|
  printf "%-15s %-15s %-15s\n", r[:policy], r[:waiting_avg], r[:turnaround_avg]
end