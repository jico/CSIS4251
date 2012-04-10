# Pager

### Page handling simulation program.

Operating Systems
Programming Assignment 4

## Usage

### Interactive

The pager can be booted in interactive mode

    ./pager -i
    
which bring up a prompt similar to the following

    Frame 0	Frame 1	
    *	*	
    >>
    
You can then request pages, which will reprint the current state of the page frames

    Frame 0	Frame 1	
    *       *	
    >> A
    Frame 0	Frame 1	
    A	      *	
    >> B
    Frame 0	Frame 1	
    A	      B	
    >> C
    Frame 0	Frame 1	
    C	      B	
    >>
    
To exit the prompt, simply type `exit`, `quit`, or `q`, whichever floats your boat.
    
### Parsing a file

You may also pass a file for the pager to parse

    ./pager filename.txt
    
The file should contain a list of page requests. There should be a single page request per line, for example:

    A
    B
    A
    C
    D
    
would be a valid file.

## Options

You can specify a few options

*   -a, --algorithm ALGORITHM
    Specify the paging policy algorithm.
    Should be one of _FIFO_ or _LRU_. Defaults to _FIFO_
*   -n, --frames NUM
    Specify the number of page frames (2-5). Defaults to 2.
*   -i, --interactive
    Start interactive mode.
  
You can view all of these options by calling `./pager -h`.

## Compatibility

Written and tested on __Ruby 1.8.7__.