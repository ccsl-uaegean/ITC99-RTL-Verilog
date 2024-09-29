# ITC99-RTL-Verilog

Circuits from https://github.com/cad-polito-it/I99T/tree/master conveted to RTL verilog.

Converted using vhd2vl by Larry Doolittle 
https://github.com/ldoolitt/vhd2vl

## Convertion process

Replaced ```bit``` and ```bit_vector``` structures with std_logic.

Removed ```type``` and ```subtype``` and replaced them with the represented structure or 1 bit registers.

Replaced ```downto``` with to.

Edited ```mem``` value assignments to single values.

Moved all declarations to the top of the file.

Removed ```for all: <module> use entity work.<module>(behav);```.


After the edits the circuits were converted using vhd2vl.

After the conversions the altered and removed parts written in Verilog by hand
and the memory structures were properly assigned values in inital blocks.


