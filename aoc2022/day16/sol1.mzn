
int: N;
int: pathsMax;

set of int: Numbers = 0..N-1;
set of int: Opts = -1..N-1;
set of int: Paths = 0..pathsMax-1;

array[Numbers] of string: names;
array[Numbers] of int: flowRates;
array[Numbers, Paths] of Opts: paths;
