module MemvUtils
  
  # Parses a given memory size string
  # (i.e. "42M", "16kb", etc.) and converts
  # it to bytes.
  #
  # Units are case insensitive and one of 
  # k (Kilobytes), m (Megabytes), or g (Gigabytes).
  def MemvUtils.parse_size(size)
    unitFactor = 2 ** 0;
        
    # Identify the units
    size.scan(/k|m|g/i) { |units|
      units.downcase
      unitFactor = 2 ** { 'k' => 10, 'm' => 20, 'g' => 30 }.fetch(units)
    }
    return /\d+/.match(size).to_s.to_i * unitFactor
  end
  
  # Display a help menu
  def MemvUtils.show_help()
    puts "Usage information:"
    methods = { "a | alloc SIZE"  => "allocate memory for a job of size SIZE",
                "d | dealloc JOB" => "deallocate process id JOB",
                "j | jobs"        => "display the currently running processes",
                "p | partitions"  => "display the partition table",
                "f | fragmentation" => "display internal fragmentation",
                "help"        => "show this help menu"}
    methods.each { |key,val| puts "\t#{key.ljust(35)}#{val}" }
  end
  
end