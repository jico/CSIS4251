class MemManager < Object
  
  # Create a new instance of MemManager
  # @param memsize Integer Memory size in bytes
  # @param opts Hash Options hash for environment
  #   - dynamic Boolean Set dynamic partitioning
  #   - partSize Integer Partition size in bytes 
  #     Must be passed if dynamic is false
  #   - algorithm String Allocation algorithm
  #     Must be one of fixed, best, next, worst
  def initialize(memsize, opts)
    @memsize, @algorithm, @jobIndex = memsize, opts[:algorithm], 1
    @partitions, @waiting, @jobs = [], {}, {}
    @lastAddressIndex = 0 if opts[:algorithm] == "next"
    @dynamic = opts[:dynamic] || true
    set_fixed_partitions(opts[:partSize]) unless opts[:dynamic]
  end
  
  # Prints the partition table in its current state
  def show_partition_table()
    puts "Address".ljust(12) + "Size".ljust(8) + "Access".ljust(8) + "Status"
    @partitions.each do |row|
      puts  "#{row.hex_address.ljust(12)}#{row.size.to_s.ljust(8)}" + 
            "#{row.access.to_s.ljust(8)}#{row.status}"
    end
  end
  
  # Prints the jobs table for running/waiting jobs
  def show_jobs()
    puts "Running jobs:\n" + "pid".ljust(15) + "address"
    @jobs.each { |i,val| puts "#{val.pid.to_s.ljust(15)}#{@partitions[val.pindex].hex_address}" }
    puts "\nWaiting jobs:\n" + "pid".ljust(15) + "size" unless @waiting.empty?
    @waiting.each { |i,val| puts "#{val.pid.to_s.ljust(15)}#{val.size}" }
  end
  
  def allocate(jobsize, algorithm)
    job = create_job(jobsize)
    return job.pid if @dynamic && dynamic_alloc(job) 
    case algorithm
    when 'first'
      @partitions.each_with_index do |p, i|
        job.pindex, p.status, p.access, @jobs[job.pid] = i, 1, job.pid, job if (p.size >= job.size && p.status == 0)
      end
    when 'best'
       # Find the best fit (least wasted space)    
        best = bestIndex = nil
        @partitions.each_with_index do |p, i|
          if (p.size >= job.size && p.status == 0)
            diff = p.size - job.size
            best, bestIndex = diff, i if !best || diff < best
          end
        end
        # Assign if a space is found, otherwise add to waiting
        assign!(job, bestIndex) if best
    when 'next'        
      # Start search from last allocated address to end
      @lastAddressIndex.upto(@partitions.length-1) do |i|
        if (@partitions[i].size >= job.size && @partitions[i].status == 0)
          @lastAddressIndex = i
          assign!(job,i)
        end
      end
      # Continue searching from beginning to last address
      unless @lastAddressIndex == 0
        0.upto(@lastAddressIndex-1) do |i|
          if (@partitions[i].size >= job.size && @partitions[i].status == 0)
            @lastAddressIndex = i
            assign!(job, i)
          end
        end
      end
    when 'worst'
      worst = worstIndex = nil
      @partitions.each_with_index do |p, i|
        if (p.size >= job.size && p.status == 0)
          diff = p.size - job.size
          worst, worstIndex = diff, i if !worst || diff > worst
        end
      end
      assign!(job, worstIndex) if worst
    end
    
    return job.pindex && job.pid || (@waiting[job.pid] = job) && false
  end
  
  # Deallocate a job
  # @param pid Integer The process/job ID to kill
  def deallocate(pid)
    job = @jobs[pid] if @jobs.has_key? pid
    @partitions[job.pindex].status = @partitions[job.pindex].access = 0
    @jobs.delete(pid)
  end
  
  # Calculate internal fragmentation
  # @return Integer Amount of fragmentation in KBs
  def calculate_fragmentation()
    fragged = 0
    @partitions.each { |p| fragged += p.size - @jobs[p.access].size if p.status == 1 }
    return fragged
  end
  
  # Inner Job class
  class Job < Object
    attr_accessor :pindex, :pid, :size

    def initialize(pid, size)
      @pid, @size = pid, size
    end
  end
  
  # Inner Partition class
  class Partition < Object
    attr_accessor :size, :address, :access, :status

    def initialize(size=0, address=0, access=0, status=0)
      @size, @address, @access, @status = size, address, access, status
    end
    
    # Return the hexadecimal address representation
    def hex_address()
      return "0x#{@address.to_s(16).rjust(8,'0')}"
    end
  end
  
  private
  
    def set_fixed_partitions(size=0)
      (0..@memsize).step(size) { |i|
        size = [size, @memsize-i].min
        @partitions << Partition.new(size, i)
      }
    end

    def create_job(size)
      @jobIndex += 1
      return Job.new(@jobIndex - 1, size)
    end
    
    def dynamic_alloc(job)
      if partitioned = dynamic_partition(job.size, job.pid)
        job.pindex, @jobs[job.pid] = @partitions.length - 1, job
        return job.pid
      else
        @dynamic = false
        return false
      end
    end
    
    def dynamic_partition(size, access)
      address = @partitions.empty? ? 0 : @partitions.last.address + @partitions.last.size + 1
      return false if address > @memsize
      @partitions << Partition.new(size, address, access, 1)
    end
    
    def assign!(job, index)
      job.pindex, @partitions[index].status, @partitions[index].access, @jobs[job.pid] = index, 1, job.pid, job
    end
  
end