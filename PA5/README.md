# Scheduler

Process scheduler simulation.
Operating Systems
Programming Assignment 5.

# Usage

Simply execute the script

    ./scheduler.rb
    
or open the Windows batch file `launch.bat`.

This will open the console with directions on how to proceed.
The input expects a series of data

    arrival_time cpu_cycles
    
which is merely two digits separated by whitespace. Press RETURN to enter the next row of data. When you're finished, submit a blank line or 'end'. 

The results of the simulation, including the average waiting time and turnaround time for each scheduling policy will be printed.

# Example input

    Starting process scheduler simulator.

    Enter the process data in the following format:
    arrival_time cpu_cycles

    Parameters must be separated with spaces.
    arrival_time must be in increasing order.
    Enter blank or 'end' when finished.
    >> 0 8
    >> 1 4
    >> 2 9
    >> 3 5
    >>