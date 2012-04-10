# memv

Virtual memory manager simulator.

Supports __Ruby 1.8.7__.

## Usage information

### Configuring the environment

Run `./memv -h` to display the help menu.

    Usage: memv [options]
        -m, --memory-size SIZE           Set memory size.
        -p, --partition SIZE             Set fixed partitions of size SIZE
                                         Defaults to dynamic partitions if unspecified
        -a, --algorithm ALGORITHM        Set the allocation algorithm (first|best|next|worst)
                                         Default: "first"
        -h, --help                       Display this help screen
        
So for example, to create a simulation with 1MB of memory, using fixed partitions of size 100KB, and best-fit allocation algorithm:

    ./memv -m 1m -p 100k -a best
    
### Interactive console

Once you've booted up an environment, you can play with the memory manager by allocating/deallocating jobs, as well as viewing the jobs/partitions tables.

You can run `h` or `help` to display a help menu.

    Usage information:
    	a | alloc SIZE                     allocate memory for a job of size SIZE
    	j | jobs                           display the currently running processes
    	p | partitions                     display the partition table
    	d | dealloc JOB                    deallocate process id JOB
    	f | fragmentation                  display internal fragmentation
    	help                               show this help menu
    	
To allocate a new job of size 10KB
    
    alloc 10k
    
or

    a 10k
    
Allocating a new job returns the process ID (job number). If the job is not successfully allocated memory, it is placed in the waiting queue and the call returns `false`.

To deallocate a job, specify the process ID to kill:

    dealloc 1
    
or

    d 1
    
Display the running and waiting jobs tables with `jobs` or `j`.

Similarly, you can print the partitions table with `partitions` or `p`.

You can check the current internal fragmentation as well using the 'fragmentation' or 'f' command. The return value is measured in bytes.

## Windows usage

I'm assuming you have Ruby installed on your Windows machine. If not, you can use [Ruby Installer for Windows](http://rubyinstaller.org/ "RubyInstaller for Windows") to get it.

There's a Windows batch file conveniently included, with contents similar to:

    ruby memv -m 1m -p 100k -a best
    
Just make sure all the files are in the current directory. Double click the `.bat` file to launch the program with the configured settings. All of the configuration and usage settings are the same, so refer to the above information.